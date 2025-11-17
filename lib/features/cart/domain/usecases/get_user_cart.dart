import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';

class GetUserCart {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  GetUserCart(this._cartRepository, this._productRepository);

  Future<List<CartProduct>> call(int userId) async {
    final cartItems = await _cartRepository.getUserCart(userId);

    final List<CartProduct> cartProducts = [];
    for (var item in cartItems) {
      final product = await _productRepository.getProductById(item.productId);
      cartProducts.add(CartProduct(product: product, quantity: item.quantity));
    }

    return cartProducts;
  }
}
