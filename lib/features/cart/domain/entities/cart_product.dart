import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

class CartProduct {
  final Product product;
  int quantity;

  CartProduct({required this.product, this.quantity = 1});
}