import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductController extends ChangeNotifier {
  final ProductService _productService;

  ProductController(this._productService);

  List<Product> _products = [];

  List<Product> get products => _products;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _productService.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
