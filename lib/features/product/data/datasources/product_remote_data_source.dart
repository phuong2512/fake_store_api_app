import 'package:dio/dio.dart';
import 'package:fake_store_api_app/features/product/data/models/product_remote_model.dart';

class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource(this._dio);

  Future<List<ProductRemoteModel>> getProducts() async {
    final response = await _dio.get('/products');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data.map((json) => ProductRemoteModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  Future<ProductRemoteModel> getProductById(int id) async {
    final response = await _dio.get('/products/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductRemoteModel.fromJson(response.data);
    }
    throw Exception('Failed to load product');
  }
}
