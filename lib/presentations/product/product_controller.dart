import 'dart:async';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/data/repositories/product_repository.dart';

class ProductController {
  final ProductRepository _productRepository;

  final StreamController<List<Product>> _productsController;
  final StreamController<bool> _loadingController;

  List<Product> _products = [];
  bool _isLoading = false;

  ProductController(this._productRepository)
    : _productsController = StreamController<List<Product>>.broadcast(),
      _loadingController = StreamController<bool>.broadcast() {
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
      final products = await _productRepository.getProducts();
      _emitProducts(products);
      _emitLoading(false);
    } catch (e) {
      _emitProducts([]);
      _emitLoading(false);
    }
  }

  void dispose() {
    _productsController.close();
    _loadingController.close();
  }
}
