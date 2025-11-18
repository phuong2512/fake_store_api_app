import 'dart:async';
import 'dart:developer';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_products.dart';

class ProductListController {
  final GetProducts _getProducts;
  final AuthRepository _authRepository;

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();
  final StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();

  List<Product> _products = [];
  bool _isLoading = false;

  ProductListController({
    required GetProducts getProducts,
    required AuthRepository authRepository,
  }) : _getProducts = getProducts,
       _authRepository = authRepository {
    log('✅ ProductListController INIT');
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
    } catch (e) {
      log('❌ Error fetching products: $e');
      _emitProducts([]);
    } finally {
      _emitLoading(false);
    }
  }

  void dispose() {
    log('❌ ProductListController DISPOSE');
    _productsController.close();
    _loadingController.close();
  }

  void logout() {
    _authRepository.logout();
    _emitProducts([]);
    _emitLoading(false);
  }
}
