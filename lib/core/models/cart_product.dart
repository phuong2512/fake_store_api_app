import 'package:fake_store_api_app/core/models/product.dart';

class CartProductModel {
  final ProductModel product;
  final int quantity;

  const CartProductModel({required this.product, required this.quantity});
}
