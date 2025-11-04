import 'package:fake_store_api_app/data/models/cart_product.dart';
import 'package:fake_store_api_app/data/services/cart_service.dart';
import 'package:fake_store_api_app/data/services/product_service.dart';
import 'package:fake_store_api_app/data/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartService _cartService;
  final ProductService _productService;

  CartRepositoryImpl(this._cartService, this._productService);

  @override
  Future<List<CartProduct>> getUserCart(int userId) async {
    final carts = await _cartService.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);

    final List<CartProduct> cartProducts = [];

    if (userCarts.isNotEmpty) {
      for (var cart in userCarts) {
        final List products = cart['products'];
        for (var cartProduct in products) {
          final int productId = cartProduct['productId'];
          final product = await _productService.getProductById(productId);
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

  @override
  Future<int?> getCurrentCartId(int userId) async {
    final carts = await _cartService.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);
    if (userCarts.isNotEmpty) {
      final cartId = userCarts.first['id'];
      return cartId;
    }
    return null;
  }

  @override
  Future<bool> addToCart(
    int? cartId,
    int productId,
    int quantity,
    int userId,
  ) async {
    final result = await _cartService.addToCart(
      cartId,
      productId,
      quantity,
      userId,
    );
    return result;
  }

  @override
  Future<bool> updateQuantity(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    final result = await _cartService.updateQuantity(cartId, products);
    return result;
  }

  @override
  Future<bool> removeFromCart(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    final result = await _cartService.removeFromCart(cartId, products);
    return result;
  }
}
