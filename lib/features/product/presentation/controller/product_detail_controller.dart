import 'dart:async';
import 'dart:developer';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class ProductDetailController {
  final CartRepository _cartRepository;

  final StreamController<bool> _addingController = StreamController<bool>.broadcast();
  final StreamController<bool> _isInCartController = StreamController<bool>.broadcast();

  bool _isAdding = false;
  bool _isInCart = false;

  ProductDetailController({required CartRepository cartRepository})
    : _cartRepository = cartRepository {
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
    if (!_addingController.isClosed) {
      _addingController.add(adding);
    }
  }

  void _emitIsInCart(bool inCart) {
    _isInCart = inCart;
    if (!_isInCartController.isClosed) {
      _isInCartController.add(inCart);
    }
  }

  // Check if product is in cart by checking local DB
  Future<void> checkProductInCart(int userId, int productId) async {
    try {
      final cartItems = await _cartRepository.getUserCart(userId);
      final isInCart = cartItems.any((item) => item.productId == productId);
      _emitIsInCart(isInCart);
    } catch (e) {
      log('❌ Error checking product in cart: $e');
      _emitIsInCart(false);
    }
  }

  Future<bool> addToCart({
    required int? cartId,
    required int productId,
    required int quantity,
    required int userId,
  }) async {
    _emitAdding(true);

    try {
      final success = await _cartRepository.addToCart(
        cartId,
        productId,
        quantity,
        userId,
      );

      if (success) {
        _emitIsInCart(true);
      }

      return success;
    } catch (e) {
      log('❌ Error adding to cart: $e');
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
