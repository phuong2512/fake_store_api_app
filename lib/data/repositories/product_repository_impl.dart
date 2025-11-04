import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/data/repositories/product_repository.dart';
import 'package:fake_store_api_app/data/services/product_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;

  ProductRepositoryImpl(this._productService);

  @override
  Future<List<Product>> getProducts() async {
    final products = await _productService.getProducts();
    return products;
  }

  @override
  Future<Product> getProductById(int id) async {
    final product = await _productService.getProductById(id);
    return product;
  }
}
