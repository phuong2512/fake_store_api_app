import 'dart:developer';

import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';
import 'package:fake_store_api_app/core/repositories/product/product_repository.dart';

class GetUserCart {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  GetUserCart(this._cartRepository, this._productRepository);

  Future<List<CartProductModel>> call(int userId) async {
    final cartItems = await _cartRepository.getUserCart(userId);

    final List<CartProductModel> result = [];

    for (var item in cartItems) {
      try {
        final product = await _productRepository.getProductById(item.productId);

        result.add(CartProductModel(product: product, quantity: item.quantity));
      } catch (e) {
        log('Product not found: ${item.productId}');
      }
    }

    return result;
  }
}
