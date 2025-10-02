abstract class CartInterface {
  Future<List<dynamic>> getCarts();

  Future<Map<String, dynamic>?> getCartById(int cartId);

  Future<bool> addToCart(int? cartId, int productId, int quantity, int userId);

  Future<bool> updateQuantity(int cartId, List<Map<String, dynamic>> products);

  Future<bool> removeFromCart(int cartId, List<Map<String, dynamic>> products);
}
