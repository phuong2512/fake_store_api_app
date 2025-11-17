import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_current_cart_id.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_user_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/sync_cart_from_api.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/update_quantity.dart';

class CartController {
  final GetUserCart _getUserCart;
  final GetCurrentCartId _getCurrentCartId;
  final UpdateQuantity _updateQuantity;
  final RemoveFromCart _removeFromCart;
  final SyncCartFromApi _syncCartFromApi;

  final StreamController<List<CartProduct>> _productsController = StreamController<List<CartProduct>>.broadcast();
  final StreamController<bool> _loadingController = StreamController<bool>.broadcast();
  final StreamController<double> _totalPriceController = StreamController<double>.broadcast();

  List<CartProduct> _cartProducts = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;
  bool _isLoadedCart = false;
  int? _currentCartId;

  CartController({
    required GetUserCart getUserCart,
    required GetCurrentCartId getCurrentCartId,
    required UpdateQuantity updateQuantity,
    required RemoveFromCart removeFromCart,
    required SyncCartFromApi syncCartFromApi,
  }) : _getUserCart = getUserCart,
       _getCurrentCartId = getCurrentCartId,
       _updateQuantity = updateQuantity,
       _removeFromCart = removeFromCart,
       _syncCartFromApi = syncCartFromApi{
    dev.log('✅ CartController INIT');
    _emitProducts([]);
    _emitLoading(true);
    _emitTotalPrice(0.0);
  }

  Stream<List<CartProduct>> get productsStream => _productsController.stream;

  List<CartProduct> get cartProducts => _cartProducts;

  bool get isLoading => _isLoading;

  Stream<bool> get loadingStream => _loadingController.stream;

  double get totalPrice => _totalPrice;

  Stream<double> get totalPriceStream => _totalPriceController.stream;

  int? get currentCartId => _currentCartId;

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

  Future<void> loadCart(int userId) async {
    if (_isLoadedCart) return;

    _emitLoading(true);

    try {
      _currentCartId = await _getCurrentCartId(userId);
      final products = await _getUserCart(userId);

      _emitProducts(products);
      _emitTotalPrice(_calculateTotalPrice(products));
      _isLoadedCart = true;
    } catch (e) {
      dev.log('❌ Error loading cart: $e');
      _emitProducts([]);
      _emitTotalPrice(0.0);
    } finally {
      _emitLoading(false);
    }
  }

  Future<void> syncCart(int userId) async {
    try {
      await _syncCartFromApi(userId);

      // Reload cart after sync
      _isLoadedCart = false;
      await loadCart(userId);
    } catch (e) {
      dev.log('❌ Error syncing cart: $e');
    }
  }

  bool isProductInCart(int productId) {
    return _cartProducts.any((item) => item.product.id == productId);
  }

  Future<bool> updateQuantity(
    int productId,
    int newQuantity,
    int userId,
  ) async {
    if (_currentCartId == null) return false;

    try {
      final success = await _updateQuantity(
        cartId: _currentCartId!,
        productId: productId,
        newQuantity: newQuantity,
      );

      if (success) {
        // Reload cart from local DB after update
        _isLoadedCart = false;
        await loadCart(userId);
      }

      return success;
    } catch (e) {
      dev.log('❌ Error updating quantity: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int productId, int userId) async {
    if (_currentCartId == null) return false;

    try {
      final success = await _removeFromCart(
        cartId: _currentCartId!,
        productId: productId,
      );

      if (success) {
        // Reload cart from local DB after removal
        _isLoadedCart = false;
        await loadCart(userId);
      }

      return success;
    } catch (e) {
      dev.log('❌ Error removing from cart: $e');
      return false;
    }
  }

  Future<bool> placeOrder() async {
    await Future.delayed(const Duration(seconds: 2));

    Random random = Random();
    final success = random.nextBool();

    if (success) {
      _emitProducts([]);
      _emitTotalPrice(0.0);
      _currentCartId = null;
      _isLoadedCart = false;
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
