import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/services/product/product_dao.dart';

abstract class ProductDatabaseService {
  Future<List<ProductModel>> getAllProducts();

  Future<ProductModel?> getProductById(int id);

  Future<List<ProductModel>> getProductsByIds(List<int> ids);

  Future<void> insertProduct(ProductModel product);

  Future<void> insertProducts(List<ProductModel> products);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(ProductModel product);

  Future<void> deleteAllProducts();
}

class ProductDatabaseServiceImpl implements ProductDatabaseService {
  final ProductDao _productDao;

  ProductDatabaseServiceImpl({required ProductDao productDao})
    : _productDao = productDao;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return await _productDao.getAllProducts();
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    return await _productDao.getProductById(id);
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<int> ids) async {
    return await _productDao.getProductsByIds(ids);
  }

  @override
  Future<void> insertProduct(ProductModel product) async {
    await _productDao.insertProduct(product);
  }

  @override
  Future<void> insertProducts(List<ProductModel> products) async {
    await _productDao.insertProducts(products);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _productDao.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(ProductModel product) async {
    await _productDao.deleteProduct(product);
  }

  @override
  Future<void> deleteAllProducts() async {
    await _productDao.deleteAllProducts();
  }
}
