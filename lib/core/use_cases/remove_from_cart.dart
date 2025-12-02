import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';

class RemoveFromCart {
  final CartRepository _repository;

  RemoveFromCart(this._repository);

  Future<bool> call({required int cartId, required int productId}) async {
    return await _repository.removeFromCart(cartId, productId);
  }
}
