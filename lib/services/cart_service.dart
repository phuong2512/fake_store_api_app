import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CartService {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/carts',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<bool> addToCart(int productId, int quantity) async {
    try {
      final response = await dio.post(
        '',
        data: {
          "products": [
            {"id": productId, "quantity": quantity},
          ],
        },
      );
      debugPrint(response.data.toString());
      debugPrint(response.statusCode.toString());
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error putting cart: $e');
      return false;
    }
  }

  Future<bool> updateQuantity(int productId, int newQuantity) async {
    try {
      final response = await dio.put(
        '/7',
        data: {
          "products": [
            {"id": productId, "quantity": newQuantity},
          ],
        },
      );
      debugPrint(response.data.toString());
      debugPrint(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating product quantity: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int productId) async {
    try {
      final response = await dio.delete('/7');
      debugPrint(response.data.toString());
      debugPrint(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error removing product from cart: $e');
      return false;
    }
  }
}
