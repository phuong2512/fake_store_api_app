import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getUserCart(int userId);

  Future<int?> getCurrentCartId(int userId);

  Future<bool> addToCart(int? cartId, int productId, int quantity, int userId);

  Future<bool> updateQuantity(int cartId, List<Map<String, dynamic>> products);

  Future<bool> removeFromCart(int cartId, List<Map<String, dynamic>> products);
}
