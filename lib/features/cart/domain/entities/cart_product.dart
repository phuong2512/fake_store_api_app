import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

class CartProduct {
  final Product product;
  final int quantity;

  CartProduct({required this.product, required this.quantity});

  CartProduct copyWith({Product? product, int? quantity}) {
    return CartProduct(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
