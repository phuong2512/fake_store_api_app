import 'dart:async';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/data/repositories/product_repository.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? error;

  ProductState({required this.products, required this.isLoading, this.error});

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductController {
  final ProductRepository _productRepository;
  final StreamController<ProductState> _stateController;

  ProductController(this._productRepository)
    : _stateController = StreamController<ProductState>.broadcast() {
    _emitState(ProductState(products: [], isLoading: false));
  }

  Stream<ProductState> get state => _stateController.stream;
  ProductState? _currentState;

  ProductState get currentState =>
      _currentState ?? ProductState(products: [], isLoading: false);

  void _emitState(ProductState state) {
    if (_stateController.isClosed) return;
    _currentState = state;
    _stateController.add(state);
  }

  Future<void> fetchProducts() async {
    _emitState(currentState.copyWith(isLoading: true, error: null));

    try {
      final products = await _productRepository.getProducts();
      _emitState(ProductState(products: products, isLoading: false));
    } catch (e) {
      _emitState(
        ProductState(products: [], isLoading: false, error: e.toString()),
      );
    }
  }

  void dispose() {
    _stateController.close();
  }
}
