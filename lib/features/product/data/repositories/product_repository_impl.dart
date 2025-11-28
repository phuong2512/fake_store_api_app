import 'package:fake_store_api_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/entities/rating.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final localProducts = await _localDataSource.getAllProducts();

    if (localProducts.isNotEmpty) {
      final products = <Product>[];
      for (var productLocalModel in localProducts) {
        final ratingLocalModel = await _localDataSource.getRatingByProductId(
          productLocalModel.id,
        );
        final rating = ratingLocalModel != null
            ? ratingLocalModel.toEntity()
            : Rating(rate: 0, count: 0);

        products.add(productLocalModel.toEntity(rating));
      }
      return products;
    }

    try {
      final productRemoteModels = await _remoteDataSource.getProducts();

      await _localDataSource.deleteAllProducts();
      for (var model in productRemoteModels) {
        await _localDataSource.insertProduct(model.toLocalModel());
        await _localDataSource.insertRating(
          model.rating.toLocalModel(model.id),
        );
      }

      return productRemoteModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final localProduct = await _localDataSource.getProductById(id);

    if (localProduct != null) {
      final ratingLocalModel = await _localDataSource.getRatingByProductId(id);
      final rating = ratingLocalModel != null
          ? ratingLocalModel.toEntity()
          : Rating(rate: 0, count: 0);

      return localProduct.toEntity(rating);
    }

    final productRemoteModel = await _remoteDataSource.getProductById(id);

    await _localDataSource.insertProduct(productRemoteModel.toLocalModel());
    await _localDataSource.insertRating(
      productRemoteModel.rating.toLocalModel(id),
    );

    return productRemoteModel.toEntity();
  }

  @override
  Future<List<Product>> getProductsByIds(List<int> ids) async {
    final List<Product> products = [];
    for (int id in ids) {
      products.add(await getProductById(id));
    }
    return products;
  }
}
