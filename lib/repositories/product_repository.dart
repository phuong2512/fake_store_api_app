import 'package:fake_store_api_app/interfaces/product_interface.dart';
import 'package:fake_store_api_app/models/product.dart';

class ProductRepository {
  final ProductInterface _productService;

  ProductRepository(this._productService);

  Future<List<Product>> getProducts() async {
    return await _productService.getProducts();
  }
}