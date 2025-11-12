import 'dart:async';
import 'dart:developer';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_products.dart';

class ProductController {
  final GetProducts _getProducts;

  final StreamController<List<Product>> _productsController;
  final StreamController<bool> _loadingController;

  List<Product> _products = [];
  bool _isLoading = false;

  ProductController({required GetProducts getProducts})
      : _getProducts = getProducts,
        _productsController = StreamController<List<Product>>.broadcast(),
        _loadingController = StreamController<bool>.broadcast() {
    log('✅ ProductController INIT');
    _emitProducts([]);
    _emitLoading(false);
  }

  List<Product> get products => _products;
  Stream<List<Product>> get productsStream => _productsController.stream;

  bool get isLoading => _isLoading;
  Stream<bool> get loadingStream => _loadingController.stream;

  void _emitProducts(List<Product> products) {
    _products = products;
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

  Future<void> fetchProducts() async {
    _emitLoading(true);

    try {
      final products = await _getProducts();
      _emitProducts(products);
      _emitLoading(false);
    } catch (e) {
      _emitProducts([]);
      _emitLoading(false);
    }
  }

  void dispose() {
    log('❌ ProductController DISPOSE');
    _productsController.close();
    _loadingController.close();
  }
}
