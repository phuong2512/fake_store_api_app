import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/services/product/product_api_service.dart';
import 'package:fake_store_api_app/core/services/product/product_database_service.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductById(int id);

  Future<List<ProductModel>> getProductsByIds(List<int> ids);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _remoteDataSource;
  final ProductDatabaseService _localDataSource;

  ProductRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<ProductModel>> getProducts() async {
    final localProducts = await _localDataSource.getAllProducts();

    if (localProducts.isNotEmpty) {
      return localProducts;
    }

    try {
      final remoteProducts = await _remoteDataSource.getProducts();

      await _localDataSource.deleteAllProducts();
      await _localDataSource.insertProducts(remoteProducts);

      return remoteProducts;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final localProduct = await _localDataSource.getProductById(id);

    if (localProduct != null) {
      return localProduct;
    }

    final remoteProduct = await _remoteDataSource.getProductById(id);
    await _localDataSource.insertProduct(remoteProduct);

    return remoteProduct;
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<int> ids) async {
    return await _localDataSource.getProductsByIds(ids);
  }
}
