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

    //fetch local
    if (localProducts.isNotEmpty) {
      final products = <Product>[];
      for (var productEntity in localProducts) {
        final ratingEntity = await _localDataSource.getRatingByProductId(
          productEntity.id,
        );
        final rating = ratingEntity != null
            ? Rating(rate: ratingEntity.rate, count: ratingEntity.count)
            : Rating(rate: 0, count: 0);

        products.add(
          Product(
            id: productEntity.id,
            title: productEntity.title,
            price: productEntity.price,
            description: productEntity.description,
            category: productEntity.category,
            image: productEntity.image,
            rating: rating,
          ),
        );
      }
      return products;
    }

    // fetch api
    try {
      final productModels = await _remoteDataSource.getProducts();

      await _localDataSource.deleteAllProducts();
      for (var model in productModels) {
        await _localDataSource.insertProduct(model.toDbEntity());
        await _localDataSource.insertRating(model.rating.toDbEntity(model.id));
      }

      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final localProduct = await _localDataSource.getProductById(id);

    if (localProduct != null) {
      final ratingEntity = await _localDataSource.getRatingByProductId(id);
      final rating = ratingEntity != null
          ? Rating(rate: ratingEntity.rate, count: ratingEntity.count)
          : Rating(rate: 0, count: 0);

      return Product(
        id: localProduct.id,
        title: localProduct.title,
        price: localProduct.price,
        description: localProduct.description,
        category: localProduct.category,
        image: localProduct.image,
        rating: rating,
      );
    }

    final productModel = await _remoteDataSource.getProductById(id);

    await _localDataSource.insertProduct(productModel.toDbEntity());
    await _localDataSource.insertRating(productModel.rating.toDbEntity(id));

    return productModel.toEntity();
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
