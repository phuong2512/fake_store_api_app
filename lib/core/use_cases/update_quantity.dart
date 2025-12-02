import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';

class UpdateQuantity {
  final CartRepository _repository;

  UpdateQuantity(this._repository);

  Future<bool> call({
    required int cartId,
    required int productId,
    required int newQuantity,
  }) async {
    return await _repository.updateQuantity(cartId, productId, newQuantity);
  }
}
