import 'dart:async';
import 'dart:developer';

import 'package:fake_store_api_app/core/use_cases/add_to_cart.dart';
import 'package:fake_store_api_app/core/use_cases/get_user.dart';
import 'package:fake_store_api_app/core/use_cases/get_user_cart.dart';

class ProductDetailController {
  final GetUser _getUser;
  final GetUserCart _getUserCart;
  final AddToCart _addToCart;

  final StreamController<bool> _addingController = StreamController.broadcast();
  final StreamController<bool> _isInCartController =
      StreamController.broadcast();

  bool _isAdding = false;
  bool _isInCart = false;

  ProductDetailController({
    required GetUser getUser,
    required GetUserCart getUserCart,
    required AddToCart addToCart,
  }) : _getUserCart = getUserCart,
       _getUser = getUser,
       _addToCart = addToCart {
    log('✅ ProductDetailController INIT');
    _emitAdding(false);
    _emitIsInCart(false);
  }

  bool get isAdding => _isAdding;

  Stream<bool> get addingStream => _addingController.stream;

  bool get isInCart => _isInCart;

  Stream<bool> get isInCartStream => _isInCartController.stream;

  void _emitAdding(bool adding) {
    _isAdding = adding;
    if (!_addingController.isClosed) _addingController.add(adding);
  }

  void _emitIsInCart(bool inCart) {
    _isInCart = inCart;
    if (!_isInCartController.isClosed) _isInCartController.add(inCart);
  }

  Future<void> checkProductInCart(int productId) async {
    try {
      final currentUser = await _getUser();
      if (currentUser == null) return;
      final cartItems = await _getUserCart(currentUser.id);

      final isInCart = cartItems.any((item) => item.product.id == productId);

      _emitIsInCart(isInCart);
    } catch (e) {
      log('❌ Error checking product in cart: $e');
      _emitIsInCart(false);
    }
  }

  Future<bool> addToCart({
    required int productId,
    required int quantity,
  }) async {
    _emitAdding(true);
    final currentUser = await _getUser();
    if (currentUser == null) return false;
    try {
      final success = await _addToCart(
        productId: productId,
        quantity: quantity,
        userId: currentUser.id,
      );
      if (success) _emitIsInCart(true);
      return success;
    } catch (e) {
      return false;
    } finally {
      _emitAdding(false);
    }
  }

  void dispose() {
    log('❌ ProductDetailController DISPOSE');
    _addingController.close();
    _isInCartController.close();
  }
}
