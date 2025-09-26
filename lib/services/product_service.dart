import 'package:dio/dio.dart';
import 'package:fake_store_api_app/interfaces/product_interface.dart';
import 'package:fake_store_api_app/models/product.dart';

class ProductService implements ProductInterface {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/products',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<Product> getProductById(int id) async {
    final response = await _dio.get('/$id');
    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    }
    throw Exception('Failed to load product');
  }
}
