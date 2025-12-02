import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/core/use_cases/clear_cart.dart';
import 'package:fake_store_api_app/core/use_cases/get_current_cart_id.dart';
import 'package:fake_store_api_app/core/use_cases/get_user.dart';
import 'package:fake_store_api_app/core/use_cases/get_user_cart.dart';
import 'package:fake_store_api_app/core/use_cases/remove_from_cart.dart';
import 'package:fake_store_api_app/core/use_cases/update_quantity.dart';

class CartController {
  final GetUserCart _getUserCart;
  final GetCurrentCartId _getCurrentCartId;
  final UpdateQuantity _updateQuantity;
  final RemoveFromCart _removeFromCart;
  final ClearCart _clearCart;
  final GetUser _getUser;

  final StreamController<List<CartProductModel>> _cartProductsController =
      StreamController.broadcast();
  final StreamController<bool> _loadingController =
      StreamController.broadcast();
  final StreamController<double> _totalPriceController =
      StreamController.broadcast();

  bool _isLoadedCart = false;
  int? _currentCartId;
  List<CartProductModel> _cartProducts = [];

  CartController({
    required GetUserCart getUserCart,
    required GetCurrentCartId getCurrentCartId,
    required UpdateQuantity updateQuantity,
    required RemoveFromCart removeFromCart,
    required ClearCart clearCart,
    required GetUser getUser,
  }) : _getUserCart = getUserCart,
       _getCurrentCartId = getCurrentCartId,
       _updateQuantity = updateQuantity,
       _removeFromCart = removeFromCart,
       _clearCart = clearCart,
       _getUser = getUser {
    dev.log('✅ CartController INIT');
    _emitCart([]);
    _emitLoading(true);
    _emitTotalPrice(0.0);
  }

  List<CartProductModel> get cartProducts => _cartProducts;

  Stream<List<CartProductModel>> get cartProductsStream =>
      _cartProductsController.stream;

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<double> get totalPriceStream => _totalPriceController.stream;

  void _emitCart(List<CartProductModel> products) {
    _cartProducts = products;
    if (!_cartProductsController.isClosed) {
      _cartProductsController.add(products);
    }
  }

  void _emitLoading(bool loading) {
    if (!_loadingController.isClosed) {
      _loadingController.add(loading);
    }
  }

  void _emitTotalPrice(double price) {
    if (!_totalPriceController.isClosed) {
      _totalPriceController.add(price);
    }
  }

  double _calculateTotalPrice(List<CartProductModel> products) {
    return products.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  Future<void> loadCart() async {
    if (_isLoadedCart) return;

    _emitLoading(true);

    final currentUser = await _getUser();
    if (currentUser == null) return;
    final currentUserId = currentUser.id;

    try {
      _currentCartId = await _getCurrentCartId(currentUserId);
      final products = await _getUserCart(currentUserId);

      _emitCart(products);
      _emitTotalPrice(_calculateTotalPrice(products));
      _isLoadedCart = true;
    } catch (e) {
      dev.log('❌ Error loading cart: $e');
      _emitCart([]);
      _emitTotalPrice(0.0);
    } finally {
      _emitLoading(false);
    }
  }

  Future<bool> updateQuantity(int productId, int newQuantity) async {
    if (_currentCartId == null) return false;
    try {
      final success = await _updateQuantity(
        cartId: _currentCartId!,
        productId: productId,
        newQuantity: newQuantity,
      );

      if (success) {
        _isLoadedCart = false;
        await loadCart();
      }

      return success;
    } catch (e) {
      dev.log('❌ Error updating quantity: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int productId) async {
    if (_currentCartId == null) return false;

    try {
      final success = await _removeFromCart(
        cartId: _currentCartId!,
        productId: productId,
      );

      if (success) {
        _isLoadedCart = false;
        await loadCart();
      }

      return success;
    } catch (e) {
      dev.log('❌ Error removing from cart: $e');
      return false;
    }
  }

  Future<bool> placeOrder() async {
    await Future.delayed(const Duration(seconds: 2));

    final currentUser = await _getUser();
    if (currentUser == null) return false;
    final currentUserId = currentUser.id;

    Random random = Random();
    final success = random.nextBool();
    await _clearCart(currentUserId);

    if (success) {
      _emitCart([]);
      _emitTotalPrice(0.0);
      _currentCartId = null;
      _isLoadedCart = false;
    }

    return success;
  }

  void dispose() {
    dev.log('❌ CartController DISPOSE');
    _cartProductsController.close();
    _loadingController.close();
    _totalPriceController.close();
  }
}
