import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
