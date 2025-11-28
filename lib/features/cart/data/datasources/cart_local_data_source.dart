import 'package:fake_store_api_app/features/cart/data/datasources/cart_dao.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_local_model.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';

class CartLocalDataSource {
  final CartDao _cartDao;

  CartLocalDataSource(this._cartDao);

  Future<List<CartLocalModel>> getCartsByUserId(int userId) async {
    return await _cartDao.getCartsByUserId(userId);
  }

  Future<CartLocalModel?> getCartById(int cartId) async {
    return await _cartDao.getCartById(cartId);
  }

  Future<int> insertCart(CartLocalModel cart) async {
    return await _cartDao.insertCart(cart);
  }

  Future<void> updateCart(CartLocalModel cart) async {
    await _cartDao.updateCart(cart);
  }

  Future<void> deleteCart(CartLocalModel cart) async {
    await _cartDao.deleteCart(cart);
  }

  Future<List<CartItemLocalModel>> getCartItemsByCartId(int cartId) async {
    return await _cartDao.getCartItemsByCartId(cartId);
  }

  Future<List<CartItemLocalModel>> getCartItemsByCartIds(
    List<int> cartIds,
  ) async {
    return await _cartDao.getCartItemsByCartIds(cartIds);
  }

  Future<void> insertCartItem(CartItemLocalModel cartItem) async {
    await _cartDao.insertCartItem(cartItem);
  }

  Future<void> updateCartItem(CartItemLocalModel cartItem) async {
    await _cartDao.updateCartItem(cartItem);
  }

  Future<void> deleteCartItem(CartItemLocalModel cartItem) async {
    await _cartDao.deleteCartItem(cartItem);
  }

  Future<void> deleteCartItemsByCartId(int cartId) async {
    await _cartDao.deleteCartItemsByCartId(cartId);
  }

  Future<void> deleteCartItemByProductId(int cartId, int productId) async {
    await _cartDao.deleteCartItemByProductId(cartId, productId);
  }

  Future<CartItemLocalModel?> getCartItemByProductId(
    int cartId,
    int productId,
  ) async {
    return await _cartDao.getCartItemByProductId(cartId, productId);
  }

  Future<void> deleteCartsByUserId(int userId) async {
    await _cartDao.deleteCartsByUserId(userId);
  }

  Future<void> syncCartItems(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    await _cartDao.deleteCartItemsByCartId(cartId);
    for (var product in products) {
      await _cartDao.insertCartItem(
        CartItemLocalModel(
          cartId: cartId,
          productId: product['productId'],
          quantity: product['quantity'],
        ),
      );
    }
  }
}
