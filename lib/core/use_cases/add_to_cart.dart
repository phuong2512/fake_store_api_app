import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';

class AddToCart {
  final CartRepository _repository;

  AddToCart(this._repository);

  Future<bool> call({
    required int productId,
    required int quantity,
    required int userId,
  }) async {
    return await _repository.addToCart(productId, quantity, userId);
  }
}
