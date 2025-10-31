import 'package:dio/dio.dart';
import 'package:fake_store_api_app/presentations/cart/cart_interface.dart';
import 'package:flutter/material.dart';

class CartService implements CartInterface {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/carts',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Future<List<dynamic>> getCarts() async {
    try {
      final response = await dio.get('');
      return response.data;
    } catch (e) {
      debugPrint('Error getting carts: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getCartById(int cartId) async {
    try {
      final response = await dio.get('/$cartId');
      return response.data;
    } catch (e) {
      debugPrint('Error getting cart by ID: $e');
      return null;
    }
  }

  @override
  Future<bool> addToCart(int? cartId, int productId, int quantity, int userId) async {
    try {
      List<dynamic> products = [];
      Map<String, dynamic>? cart;

      if (cartId != null) {
        cart = await getCartById(cartId);
        if (cart != null) {
          products = List.from(cart['products']);
          final existingProductIndex = products.indexWhere((p) => p['productId'] == productId);
          if (existingProductIndex != -1) {
            products[existingProductIndex]['quantity'] += quantity;
          } else {
            products.add({"productId": productId, "quantity": quantity});
          }
        }
      }

      if (cart == null) {
        products = [{"productId": productId, "quantity": quantity}];
        final response = await dio.post(
          '',
          data: {
            "userId": userId,
            "date": DateTime.now().toIso8601String(),
            "products": products,
          },
        );
        return response.statusCode == 201;
      }

      final response = await dio.put(
        '/$cartId',
        data: {
          "userId": cart['userId'],
          "date": cart['date'] ?? DateTime.now().toIso8601String(),
          "products": products,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      return false;
    }
  }

  @override
  Future<bool> updateQuantity(
      int cartId,
      List<Map<String, dynamic>> products,
      ) async {
    try {
      final cart = await getCartById(cartId);
      final response = await dio.put(
        '/$cartId',
        data: {
          "userId": cart?['userId'],
          "date": cart?['date'],
          "products": products,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating product quantity: $e');
      return false;
    }
  }

  @override
  Future<bool> removeFromCart(
      int cartId,
      List<Map<String, dynamic>> products,
      ) async {
    try {
      final cart = await getCartById(cartId);
      final response = await dio.put(
        '/$cartId',
        data: {
          "userId": cart?['userId'],
          "date": cart?['date'],
          "products": products,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error removing product from cart: $e');
      return false;
    }
  }
}
