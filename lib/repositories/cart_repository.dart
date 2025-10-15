import 'package:fake_store_api_app/interfaces/cart_interface.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:fake_store_api_app/repositories/product_repository.dart';

class CartRepository {
  final CartInterface _cartService;
  final ProductRepository _productRepository;

  CartRepository(this._cartService, this._productRepository);

  Future<List<CartProduct>> getUserCart(int userId) async {
    final carts = await _cartService.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);

    final List<CartProduct> cartProducts = [];

    if (userCarts.isNotEmpty) {
      for (var cart in userCarts) {
        final List products = cart['products'];
        for (var cartProduct in products) {
          final int productId = cartProduct['productId'];
          final product = await _productRepository.getProductById(productId);
          final int quantity = cartProduct['quantity'];

          final index = cartProducts.indexWhere(
            (item) => item.product.id == productId,
          );

          if (index != -1) {
            cartProducts[index].quantity += quantity;
          } else {
            cartProducts.add(CartProduct(product: product, quantity: quantity));
          }
        }
      }
    }

    return cartProducts;
  }

  Future<int?> getCurrentCartId(int userId) async {
    final carts = await _cartService.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);

    if (userCarts.isNotEmpty) {
      return userCarts.first['id'];
    }
    return null;
  }

  Future<bool> addToCart(
    int? cartId,
    int productId,
    int quantity,
    int userId,
  ) async {
    return await _cartService.addToCart(cartId, productId, quantity, userId);
  }

  Future<bool> updateQuantity(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    return await _cartService.updateQuantity(cartId, products);
  }

  Future<bool> removeFromCart(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    return await _cartService.removeFromCart(cartId, products);
  }
}
