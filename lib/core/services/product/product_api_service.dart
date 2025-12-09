import 'package:dio/dio.dart';
import 'package:fake_store_api_app/core/models/product.dart';

abstract class ProductApiService {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel> getProductById(int id);
}

class ProductApiServiceImpl implements ProductApiService {
  final Dio _dio;

  ProductApiServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get('');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await _dio.get('/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to load product');
  }
}
