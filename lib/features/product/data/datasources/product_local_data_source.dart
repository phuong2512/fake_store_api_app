import 'package:fake_store_api_app/features/product/data/datasources/product_dao.dart';
import 'package:fake_store_api_app/features/product/data/models/product_entity.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_entity.dart';

class ProductLocalDataSource {
  final ProductDao _productDao;

  ProductLocalDataSource(this._productDao);

  Future<List<ProductEntity>> getAllProducts() async {
    return await _productDao.getAllProducts();
  }

  Future<ProductEntity?> getProductById(int id) async {
    return await _productDao.getProductById(id);
  }

  Future<List<ProductEntity>> getProductsByIds(List<int> ids) async {
    return await _productDao.getProductsByIds(ids);
  }

  Future<void> insertProduct(ProductEntity product) async {
    await _productDao.insertProduct(product);
  }

  Future<void> insertProducts(List<ProductEntity> products) async {
    await _productDao.insertProducts(products);
  }

  Future<void> updateProduct(ProductEntity product) async {
    await _productDao.updateProduct(product);
  }

  Future<void> deleteProduct(ProductEntity product) async {
    await _productDao.deleteProduct(product);
  }

  Future<void> deleteAllProducts() async {
    await _productDao.deleteAllProducts();
  }

  Future<RatingEntity?> getRatingByProductId(int productId) async {
    return await _productDao.getRatingByProductId(productId);
  }

  Future<void> insertRating(RatingEntity rating) async {
    await _productDao.insertRating(rating);
  }

  Future<void> insertRatings(List<RatingEntity> ratings) async {
    await _productDao.insertRatings(ratings);
  }

  Future<void> updateRating(RatingEntity rating) async {
    await _productDao.updateRating(rating);
  }
}
