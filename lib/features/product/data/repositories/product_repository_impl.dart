import 'package:fake_store_api_app/features/product/data/datasources/product_data_source.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await _dataSource.getProducts();
    return productModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final productModel = await _dataSource.getProductById(id);
    return productModel.toEntity();
  }

  @override
  Future<List<Product>> getProductsByIds(List<int> ids) async {
    final List<Product> products = [];
    for (int id in ids) {
      products.add(await getProductById(id));
    }
    return products;
  }
}