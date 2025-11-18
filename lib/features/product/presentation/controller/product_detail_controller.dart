import 'dart:async';
import 'dart:developer';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class ProductDetailController {
  final CartRepository _cartRepository;
  final AuthRepository _authRepository;

  final StreamController<bool> _addingController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isInCartController =
      StreamController<bool>.broadcast();

  bool _isAdding = false;
  bool _isInCart = false;

  ProductDetailController({
    required CartRepository cartRepository,
    required AuthRepository authRepository,
  }) : _cartRepository = cartRepository,
       _authRepository = authRepository {
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

  Future<void> checkProductInCart(int productId) async {
    try {
      final currentUser = await _authRepository.getUser();
      if (currentUser == null) return;
      final currentUserId = currentUser.id;
      final cartItems = await _cartRepository.getUserCart(currentUserId);
      final isInCart = cartItems.any((item) => item.productId == productId);
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
    final currentUser = await _authRepository.getUser();
    if (currentUser == null) return false;
    final currentUserId = currentUser.id;
    try {
      final success = await _cartRepository.addToCart(
        productId,
        quantity,
        currentUserId,
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
