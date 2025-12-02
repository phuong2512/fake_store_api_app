import 'package:dio/dio.dart';
import 'package:fake_store_api_app/core/models/cart.dart';

abstract class CartApiService {
  Future<List<CartModel>> getCarts();

  Future<CartModel> createCart({
    required int userId,
    required List<Map<String, dynamic>> products,
  });
}

class CartApiServiceImpl implements CartApiService {
  final Dio _dio;

  CartApiServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<CartModel>> getCarts() async {
    final response = await _dio.get('/carts');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => CartModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load carts');
  }

  @override
  Future<CartModel> createCart({
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
      return CartModel.fromJson(response.data);
    }
    throw Exception('Failed to create cart');
  }
}
