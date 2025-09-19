import 'dart:convert';

import 'package:fake_store_api_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductController extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _products = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    }
  }
}
