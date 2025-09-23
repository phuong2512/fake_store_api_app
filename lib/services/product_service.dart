import 'package:dio/dio.dart';
import 'package:fake_store_api_app/models/product.dart';

class ProductService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/products',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }
}
