import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/add_to_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_current_cart_id.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_user_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/update_quantity.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

class CartController {
  final GetUserCart _getUserCart;
  final GetCurrentCartId _getCurrentCartId;
  final AddToCart _addToCart;
  final UpdateQuantity _updateQuantity;
  final RemoveFromCart _removeFromCart;

  final StreamController<List<CartProduct>> _productsController;
  final StreamController<bool> _loadingController;
  final StreamController<double> _totalPriceController;

  List<CartProduct> _cartProducts = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;
  bool _isLoadedCart = false;
  int? _currentCartId;

  CartController({
    required GetUserCart getUserCart,
    required GetCurrentCartId getCurrentCartId,
    required AddToCart addToCart,
    required UpdateQuantity updateQuantity,
    required RemoveFromCart removeFromCart,
  })  : _getUserCart = getUserCart,
        _getCurrentCartId = getCurrentCartId,
        _addToCart = addToCart,
        _updateQuantity = updateQuantity,
        _removeFromCart = removeFromCart,
        _productsController = StreamController<List<CartProduct>>.broadcast(),
        _loadingController = StreamController<bool>.broadcast(),
        _totalPriceController = StreamController<double>.broadcast() {
    dev.log('✅ CartController INIT');
    _emitProducts([]);
    _emitLoading(true);
    _emitTotalPrice(0.0);
  }

  Stream<List<CartProduct>> get productsStream => _productsController.stream;
  bool get isLoading => _isLoading;

  Stream<bool> get loadingStream => _loadingController.stream;

  double get totalPrice => _totalPrice;
  Stream<double> get totalPriceStream => _totalPriceController.stream;

  List<CartProduct> get cartProducts => _cartProducts;

  void _emitProducts(List<CartProduct> products) {
    _cartProducts = products;
    if (!_productsController.isClosed) {
      _productsController.add(products);
    }
  }

  void _emitLoading(bool loading) {
    _isLoading = loading;
    if (!_loadingController.isClosed) {
      _loadingController.add(loading);
    }
  }

  void _emitTotalPrice(double price) {
    _totalPrice = price;
    if (!_totalPriceController.isClosed) {
      _totalPriceController.add(price);
    }
  }

  double _calculateTotalPrice(List<CartProduct> products) {
    return products.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }

  Future<void> getCart(int userId) async {
    if (_isLoadedCart) return;
    try {
      _currentCartId = await _getCurrentCartId(userId);
      final products = await _getUserCart(userId);

      _emitProducts(products);
      _emitTotalPrice(_calculateTotalPrice(products));
    } catch (e) {
      _emitProducts([]);
      _emitTotalPrice(0.0);
    } finally {
      _emitLoading(false);
      _isLoadedCart = true;
    }
  }

  bool isProductInCart(Product product) {
    return _cartProducts.any((item) => item.product.id == product.id);
  }

  Future<void> addToCart(Product product, int quantity, int userId) async {
    try {
      final success = await _addToCart(AddToCartParams(
        cartId: _currentCartId,
        productId: product.id,
        quantity: quantity,
        userId: userId,
      ));

      if (success) {
        final updatedProducts = List<CartProduct>.from(cartProducts);
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

        _emitProducts(updatedProducts);
        _emitTotalPrice(_calculateTotalPrice(updatedProducts));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    try {
      final updatedProducts = List<CartProduct>.from(_cartProducts);
      final index = updatedProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        updatedProducts[index].quantity = newQuantity;

        final productsForApi = updatedProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _updateQuantity(UpdateQuantityParams(
            cartId: _currentCartId!,
            products: productsForApi,
          ));
          _emitProducts(updatedProducts);
          _emitTotalPrice(_calculateTotalPrice(updatedProducts));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final updatedProducts = List<CartProduct>.from(_cartProducts);
      final index = updatedProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        updatedProducts.removeAt(index);

        final productsForApi = updatedProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();

        if (_currentCartId != null) {
          await _removeFromCart(RemoveFromCartParams(
            cartId: _currentCartId!,
            products: productsForApi,
          ));
          _emitProducts(updatedProducts);
          _emitTotalPrice(_calculateTotalPrice(updatedProducts));
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
      _emitProducts([]);
      _emitTotalPrice(0.0);
      _currentCartId = null;
    }

    return success;
  }

  void reset() {
    _emitProducts([]);
    _emitLoading(true);
    _emitTotalPrice(0.0);
    _currentCartId = null;
    _isLoadedCart = false;
  }

  void dispose() {
    dev.log('❌ CartController DISPOSE');
    _productsController.close();
    _loadingController.close();
    _totalPriceController.close();
  }
}
