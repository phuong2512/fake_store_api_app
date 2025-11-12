import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class GetUserCart {
  final CartRepository repository;

  GetUserCart(this.repository);

  Future<List<CartProduct>> call(int userId) => repository.getUserCart(userId);
}
