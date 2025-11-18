import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getUserCart(int userId);

  Future<int?> getCurrentCartId(int userId);

  Future<bool> addToCart(int productId, int quantity, int userId);

  Future<bool> updateQuantity(int cartId, int productId, int newQuantity);

  Future<bool> removeFromCart(int cartId, int productId);

  Future<void> syncCartFromApi(int userId);

  Future<void> clearCart(int userId);
}
