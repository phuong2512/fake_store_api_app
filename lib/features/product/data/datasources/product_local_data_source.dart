import 'package:fake_store_api_app/features/product/data/datasources/product_dao.dart';
import 'package:fake_store_api_app/features/product/data/models/product_local_model.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_local_model.dart';

class ProductLocalDataSource {
  final ProductDao _productDao;

  ProductLocalDataSource(this._productDao);

  Future<List<ProductLocalModel>> getAllProducts() async {
    return await _productDao.getAllProducts();
  }

  Future<ProductLocalModel?> getProductById(int id) async {
    return await _productDao.getProductById(id);
  }

  Future<List<ProductLocalModel>> getProductsByIds(List<int> ids) async {
    return await _productDao.getProductsByIds(ids);
  }

  Future<void> insertProduct(ProductLocalModel product) async {
    await _productDao.insertProduct(product);
  }

  Future<void> insertProducts(List<ProductLocalModel> products) async {
    await _productDao.insertProducts(products);
  }

  Future<void> updateProduct(ProductLocalModel product) async {
    await _productDao.updateProduct(product);
  }

  Future<void> deleteProduct(ProductLocalModel product) async {
    await _productDao.deleteProduct(product);
  }

  Future<void> deleteAllProducts() async {
    await _productDao.deleteAllProducts();
  }

  Future<RatingLocalModel?> getRatingByProductId(int productId) async {
    return await _productDao.getRatingByProductId(productId);
  }

  Future<void> insertRating(RatingLocalModel rating) async {
    await _productDao.insertRating(rating);
  }

  Future<void> insertRatings(List<RatingLocalModel> ratings) async {
    await _productDao.insertRatings(ratings);
  }

  Future<void> updateRating(RatingLocalModel rating) async {
    await _productDao.updateRating(rating);
  }
}
