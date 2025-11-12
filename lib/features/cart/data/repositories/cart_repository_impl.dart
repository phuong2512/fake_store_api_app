import 'package:fake_store_api_app/features/cart/data/datasources/cart_data_source.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource _cartDataSource;

  CartRepositoryImpl(this._cartDataSource);

  @override
  Future<List<CartItem>> getUserCart(int userId) async {
    final carts = await _cartDataSource.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);

    final List<CartItem> cartItems = [];

    if (userCarts.isNotEmpty) {
      for (var cart in userCarts) {
        final List products = cart['products'];
        for (var cartProduct in products) {
          cartItems.add(
            CartItem(
              productId: cartProduct['productId'],
              quantity: cartProduct['quantity'],
            ),
          );
        }
      }
    }
    final Map<int, int> consolidated = {};
    for (var item in cartItems) {
      consolidated[item.productId] =
          (consolidated[item.productId] ?? 0) + item.quantity;
    }

    return consolidated.entries
        .map((e) => CartItem(productId: e.key, quantity: e.value))
        .toList();
  }

  @override
  Future<int?> getCurrentCartId(int userId) async {
    final carts = await _cartDataSource.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);
    if (userCarts.isNotEmpty) {
      final cartId = userCarts.first['id'];
      return cartId;
    }
    return null;
  }

  @override
  Future<bool> addToCart(
    int? cartId,
    int productId,
    int quantity,
    int userId,
  ) async {
    final result = await _cartDataSource.addToCart(
      cartId,
      productId,
      quantity,
      userId,
    );
    return result;
  }

  @override
  Future<bool> updateQuantity(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    final result = await _cartDataSource.updateQuantity(cartId, products);
    return result;
  }

  @override
  Future<bool> removeFromCart(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    final result = await _cartDataSource.removeFromCart(cartId, products);
    return result;
  }
}
