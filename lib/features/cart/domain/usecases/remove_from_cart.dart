import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<bool> call(RemoveFromCartParams params) =>
      repository.removeFromCart(params.cartId, params.products);
}

class RemoveFromCartParams {
  final int cartId;
  final List<Map<String, dynamic>> products;

  RemoveFromCartParams({required this.cartId, required this.products});
}
