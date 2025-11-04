import 'package:fake_store_api_app/data/models/cart_product.dart';

abstract class CartRepository {
  Future<List<CartProduct>> getUserCart(int userId);

  Future<int?> getCurrentCartId(int userId);

  Future<bool> addToCart(int? cartId, int productId, int quantity, int userId);

  Future<bool> updateQuantity(int cartId, List<Map<String, dynamic>> products);

  Future<bool> removeFromCart(int cartId, List<Map<String, dynamic>> products);
}
