import 'dart:async';
import 'dart:math';
import 'package:fake_store_api_app/data/models/cart_product.dart';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/data/repositories/cart_repository.dart';

class CartState {
  final List<CartProduct> cartProducts;
  final bool isLoading;
  final double totalPrice;

  CartState({
    required this.cartProducts,
    required this.isLoading,
    required this.totalPrice,
  });

  CartState copyWith({
    List<CartProduct>? cartProducts,
    bool? isLoading,
    String? error,
    double? totalPrice,
  }) {
    return CartState(
      cartProducts: cartProducts ?? this.cartProducts,
      isLoading: isLoading ?? this.isLoading,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class CartController {
  final CartRepository _cartRepository;
  final StreamController<CartState> _stateController;

  final _initialState = CartState(
    cartProducts: [],
    isLoading: true,
    totalPrice: 0.0,
  );

  bool _isLoadedCart = false;
  int? _currentCartId;

  CartController(this._cartRepository)
    : _stateController = StreamController<CartState>.broadcast() {
    _emitState(_initialState);
  }

  Stream<CartState> get state => _stateController.stream;
  CartState? _currentState;

  CartState get currentState =>
      _currentState ??
      CartState(cartProducts: [], isLoading: true, totalPrice: 0.0);

  void _emitState(CartState state) {
    if (_stateController.isClosed) return;
    _currentState = state;
    _stateController.add(state);
  }

  double _calculateTotalPrice(List<CartProduct> products) {
    return products.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  Future<void> getCart(int userId) async {
    if (_isLoadedCart) {
      return;
    }

    try {
      _currentCartId = await _cartRepository.getCurrentCartId(userId);

      final products = await _cartRepository.getUserCart(userId);

      _emitState(
        CartState(
          cartProducts: products,
          isLoading: false,
          totalPrice: _calculateTotalPrice(products),
        ),
      );

      _isLoadedCart = true;
    } catch (e) {
      _emitState(
        CartState(
          cartProducts: [],
          isLoading: false,
          totalPrice: 0.0,
        ),
      );
      _isLoadedCart = true;
    }
  }

  bool isProductInCart(Product product) {
    return currentState.cartProducts.any(
      (item) => item.product.id == product.id,
    );
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
        final updatedProducts = List<CartProduct>.from(
          currentState.cartProducts,
        );
        final index = updatedProducts.indexWhere(
          (item) => item.product.id == product.id,
        );

        if (index != -1) {
          updatedProducts[index].quantity += quantity;
        } else {
          updatedProducts.add(
            CartProduct(product: product, quantity: quantity),
          );
        }

        _emitState(
          currentState.copyWith(
            cartProducts: updatedProducts,
            totalPrice: _calculateTotalPrice(updatedProducts),
          ),
        );
      } else {
        throw Exception('Failed to update cart on API');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    try {
      final updatedProducts = List<CartProduct>.from(currentState.cartProducts);
      final index = updatedProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        updatedProducts[index].quantity = newQuantity;

        final productsForApi = updatedProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _cartRepository.updateQuantity(_currentCartId!, productsForApi);

          _emitState(
            currentState.copyWith(
              cartProducts: updatedProducts,
              totalPrice: _calculateTotalPrice(updatedProducts),
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final updatedProducts = List<CartProduct>.from(currentState.cartProducts);
      final index = updatedProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        updatedProducts.removeAt(index);

        final productsForApi = updatedProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _cartRepository.removeFromCart(_currentCartId!, productsForApi);
          _emitState(
            currentState.copyWith(
              cartProducts: updatedProducts,
              totalPrice: _calculateTotalPrice(updatedProducts),
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));

    Random random = Random();
    final success = random.nextBool();

    if (success) {
      _emitState(
        CartState(cartProducts: [], isLoading: false, totalPrice: 0.0),
      );
      _currentCartId = null;
    } else {}

    return success;
  }

  void reset() {
    _emitState(_initialState);
    _currentCartId = null;
    _isLoadedCart = false;
  }

  void dispose() {
    _stateController.close();
  }
}
