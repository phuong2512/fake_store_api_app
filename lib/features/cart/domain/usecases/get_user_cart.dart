import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';

class GetUserCart {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  GetUserCart(this._cartRepository, this._productRepository);

  Future<List<CartProduct>> call(int userId) async {
    final cartItems = await _cartRepository.getUserCart(userId);
    if (cartItems.isEmpty) return [];

    final productIds = cartItems.map((item) => item.productId).toList();

    final products = await _productRepository.getProductsByIds(productIds);

    return cartItems.map((item) {
      final product = products.firstWhere((p) => p.id == item.productId);
      return CartProduct(product: product, quantity: item.quantity);
    }).toList();
  }
}
