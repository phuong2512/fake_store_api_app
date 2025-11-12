import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
  Future<List<Product>> getProductsByIds(List<int> ids);
}