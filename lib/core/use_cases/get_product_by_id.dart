import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/repositories/product/product_repository.dart';

class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  Future<ProductModel> call(int id) async {
    return await repository.getProductById(id);
  }
}
