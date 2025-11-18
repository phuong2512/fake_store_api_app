import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class ClearCart {
  final CartRepository _cartRepository;

  ClearCart(this._cartRepository);

  Future<void> call(int userId) async {
    await _cartRepository.clearCart(userId);
  }
}
