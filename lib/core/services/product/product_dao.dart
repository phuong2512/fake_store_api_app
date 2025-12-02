import 'package:fake_store_api_app/core/models/product.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products')
  Future<List<ProductModel>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id')
  Future<ProductModel?> getProductById(int id);

  @Query('SELECT * FROM products WHERE id IN (:ids)')
  Future<List<ProductModel>> getProductsByIds(List<int> ids);

  @insert
  Future<void> insertProduct(ProductModel product);

  @insert
  Future<void> insertProducts(List<ProductModel> products);

  @update
  Future<void> updateProduct(ProductModel product);

  @delete
  Future<void> deleteProduct(ProductModel product);

  @Query('DELETE FROM products')
  Future<void> deleteAllProducts();
}
