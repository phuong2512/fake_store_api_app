import 'dart:developer';

import 'package:fake_store_api_app/core/models/cart.dart';
import 'package:fake_store_api_app/core/models/cart_item.dart';
import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/core/repositories/product/product_repository.dart';
import 'package:fake_store_api_app/core/services/cart/cart_api_service.dart';
import 'package:fake_store_api_app/core/services/cart/cart_database_service.dart';

abstract class CartRepository {
  Future<List<CartProductModel>> getUserCart(int userId);

  Future<bool> addToCart(int productId, int quantity, int userId);

  Future<void> syncCartFromApi(int userId);

  Future<void> clearCart(int userId);

  Future<int?> getCurrentCartId(int userId);

  Future<bool> updateQuantity(int cartId, int productId, int newQuantity);

  Future<bool> removeFromCart(int cartId, int productId);
}

class CartRepositoryImpl implements CartRepository {
  final CartApiService _apiService;
  final CartDatabaseService _dbService;
  final ProductRepository _productRepository;

  CartRepositoryImpl(
    this._apiService,
    this._dbService,
    this._productRepository,
  );

  @override
  Future<List<CartProductModel>> getUserCart(int userId) async {
    final carts = await _dbService.getCartsByUserId(userId);
    if (carts.isEmpty) return [];

    final Map<int, int> consolidated = {};
    for (var cart in carts) {
      for (var item in cart.products) {
        consolidated[item.productId] =
            (consolidated[item.productId] ?? 0) + item.quantity;
      }
    }

    final List<CartProductModel> result = [];
    for (var entry in consolidated.entries) {
      try {
        final product = await _productRepository.getProductById(entry.key);
        result.add(CartProductModel(product: product, quantity: entry.value));
      } catch (e) {
        log('Product not found for cart item: ${entry.key}');
      }
    }
    return result;
  }

  @override
  Future<bool> addToCart(int productId, int quantity, int userId) async {
    try {
      final carts = await _dbService.getCartsByUserId(userId);

      if (carts.isNotEmpty) {
        var currentCart = carts.first;
        List<CartItemModel> updatedItems = List.from(currentCart.products);

        final existingIndex = updatedItems.indexWhere(
          (e) => e.productId == productId,
        );

        if (existingIndex != -1) {
          final existing = updatedItems[existingIndex];
          updatedItems[existingIndex] = CartItemModel(
            productId: productId,
            quantity: existing.quantity + quantity,
          );
        } else {
          updatedItems.add(
            CartItemModel(productId: productId, quantity: quantity),
          );
        }

        await _dbService.updateCart(
          currentCart.copyWith(products: updatedItems),
        );
        return true;
      }

      final newItem = CartItemModel(productId: productId, quantity: quantity);
      final newCart = CartModel(
        userId: userId,
        date: DateTime.now().toIso8601String(),
        products: [newItem],
      );

      await _dbService.insertCart(newCart);
      return true;
    } catch (e) {
      log("Error adding to cart: $e");
      return false;
    }
  }

  @override
  Future<void> syncCartFromApi(int userId) async {
    try {
      final remoteCarts = await _apiService.getCarts();
      final userCarts = remoteCarts.where((c) => c.userId == userId).toList();

      await _dbService.deleteCartsByUserId(userId);
      for (var cart in userCarts) {
        await _dbService.insertCart(cart);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> clearCart(int userId) async {
    await _dbService.deleteCartsByUserId(userId);
  }

  @override
  Future<int?> getCurrentCartId(int userId) async {
    try {
      final carts = await _dbService.getCartsByUserId(userId);
      if (carts.isNotEmpty) {
        return carts.first.id;
      }
      return null;
    } catch (e) {
      log("Error getting current cart ID: $e");
      return null;
    }
  }

  @override
  Future<bool> updateQuantity(
    int cartId,
    int productId,
    int newQuantity,
  ) async {
    try {
      final cart = await _dbService.getCartById(cartId);
      if (cart == null) return false;

      List<CartItemModel> updatedItems = List.from(cart.products);
      final index = updatedItems.indexWhere((e) => e.productId == productId);

      if (index != -1) {
        updatedItems[index] = CartItemModel(
          productId: productId,
          quantity: newQuantity,
        );
        await _dbService.updateCart(cart.copyWith(products: updatedItems));
        return true;
      }
      return false;
    } catch (e) {
      log("Error updating quantity: $e");
      return false;
    }
  }

  @override
  Future<bool> removeFromCart(int cartId, int productId) async {
    try {
      final cart = await _dbService.getCartById(cartId);
      if (cart == null) return false;

      List<CartItemModel> updatedItems = List.from(cart.products);
      final initialLength = updatedItems.length;
      updatedItems.removeWhere((e) => e.productId == productId);

      if (updatedItems.length < initialLength) {
        await _dbService.updateCart(cart.copyWith(products: updatedItems));
        return true;
      }
      return false;
    } catch (e) {
      log("Error removing from cart: $e");
      return false;
    }
  }
}
