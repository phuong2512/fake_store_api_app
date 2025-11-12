import 'package:fake_store_api_app/features/cart/data/datasources/cart_data_source.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_data_source.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource _cartDataSource;
  final ProductDataSource _productDataSource;

  CartRepositoryImpl(this._cartDataSource, this._productDataSource);

  @override
  Future<List<CartProduct>> getUserCart(int userId) async {
    final carts = await _cartDataSource.getCarts();
    final userCarts = carts.where((cart) => cart['userId'] == userId);

    final List<CartProduct> cartProducts = [];

    if (userCarts.isNotEmpty) {
      for (var cart in userCarts) {
        final List products = cart['products'];
        for (var cartProduct in products) {
          final int productId = cartProduct['productId'];
          final productModel = await _productDataSource.getProductById(
            productId,
          );
          final int quantity = cartProduct['quantity'];
          final index = cartProducts.indexWhere(
            (item) => item.product.id == productId,
          );
          if (index != -1) {
            cartProducts[index].quantity += quantity;
          } else {
            cartProducts.add(
              CartProduct(
                product: productModel.toEntity(), // Gọi .toEntity()
                quantity: quantity,
              ),
            );
          }
        }
      }
    }
    return cartProducts;
  }

  @override
  Future<int?> getCurrentCartId(int userId) async {
    final carts = await _cartDataSource.getCarts();
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
    final result = await _cartDataSource.addToCart(
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
    final result = await _cartDataSource.updateQuantity(cartId, products);
    return result;
  }

  @override
  Future<bool> removeFromCart(
    int cartId,
    List<Map<String, dynamic>> products,
  ) async {
    final result = await _cartDataSource.removeFromCart(cartId, products);
    return result;
  }
}
