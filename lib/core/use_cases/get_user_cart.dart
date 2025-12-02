import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';

class GetUserCart {
  final CartRepository _cartRepository;

  GetUserCart(this._cartRepository);

  Future<List<CartProductModel>> call(int userId) async {
    return await _cartRepository.getUserCart(userId);
  }
}
