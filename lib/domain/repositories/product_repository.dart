import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/presentations/product/product_interface.dart';

class ProductRepository {
  final ProductInterface _productService;

  ProductRepository(this._productService);

  Future<List<Product>> getProducts() async {
    return await _productService.getProducts();
  }
}
