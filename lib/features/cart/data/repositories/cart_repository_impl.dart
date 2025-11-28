import 'dart:developer';

import 'package:fake_store_api_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_local_model.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<CartItem>> getUserCart(int userId) async {
    final carts = await _localDataSource.getCartsByUserId(userId);

    if (carts.isEmpty) {
      return [];
    }

    final cartIds = carts.map((c) => c.id).whereType<int>().toList();
    final cartItems = await _localDataSource.getCartItemsByCartIds(cartIds);

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
    final carts = await _localDataSource.getCartsByUserId(userId);
    if (carts.isNotEmpty) {
      return carts.first.id;
    }
    return null;
  }

  @override
  Future<bool> addToCart(int productId, int quantity, int userId) async {
    try {
      final int? existingCartId = await getCurrentCartId(userId);

      if (existingCartId != null) {
        final localCart = await _localDataSource.getCartById(existingCartId);
        if (localCart != null) {
          final cartItems = await _localDataSource.getCartItemsByCartId(
            existingCartId,
          );

          final products = cartItems
              .map(
                (item) => {
                  'productId': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList();

          final existingItem = await _localDataSource.getCartItemByProductId(
            existingCartId,
            productId,
          );

          if (existingItem != null) {
            products.removeWhere((p) => p['productId'] == productId);
            products.add({
              'productId': productId,
              'quantity': existingItem.quantity + quantity,
            });
          } else {
            products.add({'productId': productId, 'quantity': quantity});
          }

          await _localDataSource.syncCartItems(existingCartId, products);
          return true;
        }
      }

      final products = [
        {'productId': productId, 'quantity': quantity},
      ];

      final newCartFromApi = await _remoteDataSource.createCart(
        userId: userId,
        products: products,
      );

      final localCartModel = CartLocalModel(
        userId: userId,
        date: newCartFromApi.date,
      );

      final int newLocalCartId = await _localDataSource.insertCart(
        localCartModel,
      );
      await _localDataSource.syncCartItems(newLocalCartId, products);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateQuantity(
    int cartId,
    int productId,
    int newQuantity,
  ) async {
    try {
      final localCart = await _localDataSource.getCartById(cartId);
      if (localCart == null) return false;

      final existingItem = await _localDataSource.getCartItemByProductId(
        cartId,
        productId,
      );
      if (existingItem != null) {
        await _localDataSource.updateCartItem(
          CartItemLocalModel(
            id: existingItem.id,
            cartId: cartId,
            productId: productId,
            quantity: newQuantity,
          ),
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFromCart(int cartId, int productId) async {
    try {
      final localCart = await _localDataSource.getCartById(cartId);
      if (localCart == null) return false;

      await _localDataSource.deleteCartItemByProductId(cartId, productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncCartFromApi(int userId) async {
    try {
      final remoteCarts = await _remoteDataSource.getCarts();
      final userCarts = remoteCarts
          .where((cart) => cart.userId == userId)
          .toList();

      await _localDataSource.deleteCartsByUserId(userId);

      for (var cart in userCarts) {
        final localModel = cart.toLocalModel();

        final newLocalId = await _localDataSource.insertCart(localModel);

        await _localDataSource.syncCartItems(newLocalId, cart.products);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> clearCart(int userId) async {
    try {
      final carts = await _localDataSource.getCartsByUserId(userId);
      for (var cart in carts) {
        await _localDataSource.deleteCart(cart);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
