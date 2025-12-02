import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/repositories/product/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<ProductModel>> call() async {
    return await repository.getProducts();
  }
}
