import 'package:dio/dio.dart';
import 'package:fake_store_api_app/features/product/data/models/product.dart';

class ProductDataSource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com/products',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        final products = data.map((json) => ProductModel.fromJson(json)).toList();
        return products;
      }
      throw Exception('Failed to load products');
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('/$id');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final product = ProductModel.fromJson(response.data);
        return product;
      }
      throw Exception('Failed to load product');
    } catch (e) {
      rethrow;
    }
  }
}
