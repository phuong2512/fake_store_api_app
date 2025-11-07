import 'dart:async';
import 'dart:math';
import 'package:fake_store_api_app/data/models/cart_product.dart';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/data/repositories/cart_repository.dart';

class CartController {
  final CartRepository _cartRepository;

  final StreamController<List<CartProduct>> _productsController;
  final StreamController<bool> _loadingController;
  final StreamController<double> _totalPriceController;

  List<CartProduct> _cartProducts = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;
  bool _isLoadedCart = false;
  int? _currentCartId;

  CartController(this._cartRepository)
    : _productsController = StreamController<List<CartProduct>>.broadcast(),
      _loadingController = StreamController<bool>.broadcast(),
      _totalPriceController = StreamController<double>.broadcast() {
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
    if (_isLoadedCart) {
      return;
    }
    try {
      _currentCartId = await _cartRepository.getCurrentCartId(userId);
      final products = await _cartRepository.getUserCart(userId);

      _emitProducts(products);
      _emitTotalPrice(_calculateTotalPrice(products));
      _emitLoading(false);
      _isLoadedCart = true;
    } catch (e) {
      _emitProducts([]);
      _emitTotalPrice(0.0);
      _emitLoading(false);
      _isLoadedCart = true;
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
          await _cartRepository.updateQuantity(_currentCartId!, productsForApi);
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
          await _cartRepository.removeFromCart(_currentCartId!, productsForApi);
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
    _productsController.close();
    _loadingController.close();
    _totalPriceController.close();
  }
}
