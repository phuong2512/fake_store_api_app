import 'package:fake_store_api_app/core/models/cart.dart';
import 'package:fake_store_api_app/core/services/cart/cart_dao.dart';

abstract class CartDatabaseService {
  Future<List<CartModel>> getCartsByUserId(int userId);

  Future<CartModel?> getCartById(int cartId);

  Future<int> insertCart(CartModel cart);

  Future<void> updateCart(CartModel cart);

  Future<void> deleteCart(CartModel cart);

  Future<void> deleteCartsByUserId(int userId);
}

class CartDatabaseServiceImpl implements CartDatabaseService {
  final CartDao _cartDao;

  CartDatabaseServiceImpl({required CartDao cartDao}) : _cartDao = cartDao;

  @override
  Future<List<CartModel>> getCartsByUserId(int userId) =>
      _cartDao.getCartsByUserId(userId);

  @override
  Future<CartModel?> getCartById(int cartId) => _cartDao.getCartById(cartId);

  @override
  Future<int> insertCart(CartModel cart) => _cartDao.insertCart(cart);

  @override
  Future<void> updateCart(CartModel cart) => _cartDao.updateCart(cart);

  @override
  Future<void> deleteCart(CartModel cart) => _cartDao.deleteCart(cart);

  @override
  Future<void> deleteCartsByUserId(int userId) =>
      _cartDao.deleteCartsByUserId(userId);
}
