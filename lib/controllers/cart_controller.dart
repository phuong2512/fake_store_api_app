import 'dart:math';

import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final List<CartProduct> _cartProducts = [];

  List<CartProduct> get cartProducts => _cartProducts;

  double get totalPrice {
    final total = _cartProducts.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
    return total;
  }

  bool isProductInCart(Product product) {
    return _cartProducts.any((item) => item.product.id == product.id);
  }

  Future<void> addToCart(Product product, int quantity) async {
    final index = _cartProducts.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (index != -1) {
      _cartProducts[index].quantity += quantity;
    } else {
      _cartProducts.add(CartProduct(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    final index = _cartProducts.indexWhere(
      (item) => item.product.id == product.id,
    );
    _cartProducts[index].quantity = newQuantity;
    notifyListeners();
  }

  Future<void> removeFromCart(Product product) async {
    final index = _cartProducts.indexWhere(
      (item) => item.product.id == product.id,
    );
    _cartProducts.removeAt(index);
    notifyListeners();
  }

  Future<bool> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));
    Random random = Random();
    final success = random.nextBool();
    if (!success) {
      return false;
    }
    _cartProducts.clear();
    notifyListeners();
    return true;
  }
}
