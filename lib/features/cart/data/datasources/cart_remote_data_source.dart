import 'package:dio/dio.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_remote_model.dart';

class CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSource(this._dio);

  Future<List<CartRemoteModel>> getCarts() async {
    final response = await _dio.get('/carts');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => CartRemoteModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load carts');
  }

  Future<CartRemoteModel> getCartById(int cartId) async {
    final response = await _dio.get('/carts/$cartId');
    if (response.statusCode == 200) {
      return CartRemoteModel.fromJson(response.data);
    }
    throw Exception('Failed to load cart');
  }

  Future<CartRemoteModel> createCart({
    required int userId,
    required List<Map<String, dynamic>> products,
  }) async {
    final response = await _dio.post(
      '/carts',
      data: {
        "userId": userId,
        "date": DateTime.now().toIso8601String(),
        "products": products,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CartRemoteModel.fromJson(response.data);
    }
    throw Exception('Failed to create cart');
  }

  Future<CartRemoteModel> updateCart({
    required int cartId,
    required int userId,
    required String date,
    required List<Map<String, dynamic>> products,
  }) async {
    final response = await _dio.put(
      '/carts/$cartId',
      data: {"userId": userId, "date": date, "products": products},
    );
    if (response.statusCode == 200) {
      return CartRemoteModel.fromJson(response.data);
    }
    throw Exception('Failed to update cart');
  }

  Future<bool> deleteCart(int cartId) async {
    final response = await _dio.delete('/carts/$cartId');
    return response.statusCode == 200;
  }
}
