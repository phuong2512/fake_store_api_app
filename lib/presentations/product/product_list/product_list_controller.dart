import 'dart:async';
import 'dart:developer';

import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/use_cases/get_products.dart';
import 'package:fake_store_api_app/core/use_cases/log_out_user.dart';
import 'package:flutter/material.dart';

class ProductListController extends ChangeNotifier {
  final GetProducts _getProducts;
  final LogOutUser _logOutUser;

  final StreamController<List<ProductModel>> _productsController =
      StreamController.broadcast();
  final StreamController<bool> _loadingController =
      StreamController.broadcast();

  List<ProductModel> _products = [];
  bool _isLoading = false;

  ProductListController({
    required GetProducts getProducts,
    required LogOutUser logOutUser,
  }) : _getProducts = getProducts,
       _logOutUser = logOutUser {
    log('✅ ProductListController INIT');
    _emitProducts([]);
    _emitLoading(false);
  }

  List<ProductModel> get products => _products;

  Stream<List<ProductModel>> get productsStream => _productsController.stream;

  bool get isLoading => _isLoading;

  Stream<bool> get loadingStream => _loadingController.stream;

  void _emitProducts(List<ProductModel> products) {
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

  @override
  void dispose() {
    log('❌ ProductListController DISPOSE');
    _productsController.close();
    _loadingController.close();
    super.dispose();
  }

  void logOut() {
    _logOutUser();
    _emitProducts([]);
    _emitLoading(false);
  }
}
