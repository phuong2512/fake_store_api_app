import 'package:fake_store_api_app/features/product/data/models/product_local_model.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_local_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products')
  Future<List<ProductLocalModel>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id')
  Future<ProductLocalModel?> getProductById(int id);

  @Query('SELECT * FROM products WHERE id IN (:ids)')
  Future<List<ProductLocalModel>> getProductsByIds(List<int> ids);

  @insert
  Future<void> insertProduct(ProductLocalModel product);

  @insert
  Future<void> insertProducts(List<ProductLocalModel> products);

  @update
  Future<void> updateProduct(ProductLocalModel product);

  @delete
  Future<void> deleteProduct(ProductLocalModel product);

  @Query('DELETE FROM products')
  Future<void> deleteAllProducts();

  @Query('SELECT * FROM ratings WHERE productId = :productId')
  Future<RatingLocalModel?> getRatingByProductId(int productId);

  @insert
  Future<void> insertRating(RatingLocalModel rating);

  @insert
  Future<void> insertRatings(List<RatingLocalModel> ratings);

  @update
  Future<void> updateRating(RatingLocalModel rating);

  @delete
  Future<void> deleteRating(RatingLocalModel rating);
}
