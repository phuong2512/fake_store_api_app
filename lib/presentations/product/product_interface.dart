import 'package:fake_store_api_app/data/models/product.dart';

abstract class ProductInterface {
  Future<List<Product>> getProducts();

  Future<Product> getProductById(int id);
}
