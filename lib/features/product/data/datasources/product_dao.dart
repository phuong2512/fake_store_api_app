import 'package:fake_store_api_app/features/product/data/models/product_entity.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products')
  Future<List<ProductEntity>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id')
  Future<ProductEntity?> getProductById(int id);

  @Query('SELECT * FROM products WHERE id IN (:ids)')
  Future<List<ProductEntity>> getProductsByIds(List<int> ids);

  @insert
  Future<void> insertProduct(ProductEntity product);

  @insert
  Future<void> insertProducts(List<ProductEntity> products);

  @update
  Future<void> updateProduct(ProductEntity product);

  @delete
  Future<void> deleteProduct(ProductEntity product);

  @Query('DELETE FROM products')
  Future<void> deleteAllProducts();

  @Query('SELECT * FROM ratings WHERE productId = :productId')
  Future<RatingEntity?> getRatingByProductId(int productId);

  @insert
  Future<void> insertRating(RatingEntity rating);

  @insert
  Future<void> insertRatings(List<RatingEntity> ratings);

  @update
  Future<void> updateRating(RatingEntity rating);

  @delete
  Future<void> deleteRating(RatingEntity rating);
}