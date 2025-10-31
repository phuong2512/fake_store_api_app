import 'dart:developer' as dev;
import 'dart:math';
import 'package:fake_store_api_app/data/models/cart_product.dart';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/domain/repositories/cart_repository.dart';
import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final CartRepository _cartRepository;
  bool _isLoadedCart = false;
  bool _isLoading = true;
  int? _currentCartId;

  CartController(this._cartRepository);

  bool get isLoading => _isLoading;
  final List<CartProduct> _cartProducts = [];

  List<CartProduct> get cartProducts => _cartProducts;

  double get totalPrice {
    final total = _cartProducts.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
    return total;
  }

  Future<void> getCart(int userId) async {
    if (!_isLoadedCart) {
      try {
        _currentCartId = await _cartRepository.getCurrentCartId(userId);
        final products = await _cartRepository.getUserCart(userId);
        _cartProducts.addAll(products);
      } catch (e) {
        debugPrint('Error loading cart: $e');
      } finally {
        _isLoadedCart = true;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  bool isProductInCart(Product product) {
    return _cartProducts.any((item) => item.product.id == product.id);
  }

  Future<void> addToCart(Product product, int quantity, int userId) async {
    try {
      final success = await _cartRepository.addToCart(
        _currentCartId,
        product.id,
        quantity,
        userId,
      );

      if (success) {
        final index = _cartProducts.indexWhere(
          (item) => item.product.id == product.id,
        );

        if (index != -1) {
          _cartProducts[index].quantity += quantity;
        } else {
          _cartProducts.add(CartProduct(product: product, quantity: quantity));
        }
        notifyListeners();
      } else {
        debugPrint('Failed to update cart on API');
      }
    } catch (e) {
      debugPrint('Error add: $e');
      rethrow;
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    try {
      final index = _cartProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        _cartProducts[index].quantity = newQuantity;
        final productsForApi = _cartProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _cartRepository.updateQuantity(_currentCartId!, productsForApi);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error update: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final index = _cartProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        _cartProducts.removeAt(index);
        final productsForApi = _cartProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _cartRepository.removeFromCart(_currentCartId!, productsForApi);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error remove: $e');
      rethrow;
    }
  }

  Future<bool> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));
    Random random = Random();
    final success = random.nextBool();

    if (success) {
      _cartProducts.clear();
      _currentCartId = null;
      notifyListeners();
    }

    return success;
  }

  @override
  void dispose() {
    _currentCartId = null;
    _isLoadedCart = false;
    _isLoading = true;
    _cartProducts.clear();
    dev.log('Cart Controller DISPOSE');
    super.dispose();
  }
}
