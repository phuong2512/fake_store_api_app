import 'dart:math';

import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:fake_store_api_app/services/cart_service.dart';
import 'package:fake_store_api_app/services/product_service.dart';
import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final CartService _cartService;
  final ProductService _productService;
  bool _isLoadedCart = false;
  bool _isLoading = true;
  int? _currentCartId;

  bool get isLoading => _isLoading;

  CartController(this._cartService, this._productService);

  final List<CartProduct> _cartProducts = [];

  List<CartProduct> get cartProducts => _cartProducts;

  double get totalPrice {
    final total = _cartProducts.fold(0.0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
    return total;
  }

  Future<void> getCart(int userId) async {
    if (!_isLoadedCart) {
      final carts = await _cartService.getCarts();
      final currentUserCarts = carts.where((cart) => cart['userId'] == userId);
      if (currentUserCarts.isNotEmpty) {
        _currentCartId = currentUserCarts.first['id'];
        for (var cart in currentUserCarts) {
          final List products = cart['products'];
          for (var cartProduct in products) {
            final int productId = cartProduct['productId'];
            final product = await _productService.getProductById(productId);
            final int quantity = cartProduct['quantity'];
            final index = _cartProducts.indexWhere(
              (item) => item.product.id == productId,
            );
            if (index != -1) {
              _cartProducts[index].quantity += quantity;
            } else {
              _cartProducts.add(
                CartProduct(product: product, quantity: quantity),
              );
            }
          }
        }
      } else {
        _currentCartId = null; // No cart exists for this user
      }
      _isLoadedCart = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isProductInCart(Product product) {
    return _cartProducts.any((item) => item.product.id == product.id);
  }

  Future<void> addToCart(Product product, int quantity) async {
    try {
      // Call addToCart with userId (e.g., 10 for jimmie_k)
      final success = await _cartService.addToCart(
        _currentCartId,
        product.id,
        quantity,
        10, // Replace with dynamic userId from your auth system
      );
      if (success) {
        // If a new cart was created, fetch the latest cart to get its ID
        if (_currentCartId == null) {
          final carts = await _cartService.getCarts();
          final newCart = carts.firstWhere(
            (cart) => cart['userId'] == 10, // Replace with dynamic userId
            orElse: () => null,
          );
          if (newCart != null) {
            _currentCartId = newCart['id'];
          }
        }
        // Update local cart products
        final index = _cartProducts.indexWhere(
          (item) => item.product.id == product.id,
        );
        if (index != -1) {
          _cartProducts[index].quantity += quantity;
        } else {
          _cartProducts.add(CartProduct(product: product, quantity: quantity));
        }
        notifyListeners();
      } else {
        debugPrint('Failed to update cart on API');
      }
    } catch (e) {
      debugPrint('Error add: $e');
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    try {
      final index = _cartProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        _cartProducts[index].quantity = newQuantity;
        final productsForApi = _cartProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();
        if (_currentCartId != null) {
          await _cartService.updateQuantity(_currentCartId!, productsForApi);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error update: $e');
    }
  }

  Future<void> removeFromCart(Product product) async {
    try {
      final index = _cartProducts.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        _cartProducts.removeAt(index);
        final productsForApi = _cartProducts
            .map((p) => {"productId": p.product.id, "quantity": p.quantity})
            .toList();
        if (_currentCartId != null) {
          await _cartService.removeFromCart(_currentCartId!, productsForApi);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error remove: $e');
    }
  }

  Future<bool> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
    Random random = Random();
    final success = random.nextBool();
    if (!success) {
      return false;
    }
    _cartProducts.clear();
    _currentCartId = null; // Reset cart ID after order
    notifyListeners();
    return true;
  }

  void clearCart() {
    _cartProducts.clear();
    _currentCartId = null;
    _isLoadedCart = false;
    _isLoading = true;
    notifyListeners();
  }

  void showOrderDialog(BuildContext context, bool isOrderSuccessful) {
    if (isOrderSuccessful) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Order Successful', textAlign: TextAlign.center),
          content: Text(
            'Your orders have been placed successfully!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Order Failed', textAlign: TextAlign.center),
          content: Text(
            'Your orders have been placed failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void showCartOptions(BuildContext context, CartProduct cartProduct) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    showEditDialog(context, cartProduct);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove'),
                  onTap: () {
                    Navigator.pop(context);
                    showRemoveDialog(context, cartProduct);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditDialog(BuildContext context, CartProduct cartProduct) {
    final quantityTextController = TextEditingController(
      text: cartProduct.quantity.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quantity', textAlign: TextAlign.center),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: quantityTextController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final newQuantity = int.parse(quantityTextController.text);
                    try {
                      await updateQuantity(cartProduct.product, newQuantity);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Product's quantity updated")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Product's quantity update failed"),
                        ),
                      );
                      debugPrint(e.toString());
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showRemoveDialog(BuildContext context, CartProduct cartProduct) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Product', textAlign: TextAlign.center),
          content: Text(
            'Are you sure you want to remove this product from your cart?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await removeFromCart(cartProduct.product);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product removed from cart')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product removed from cart failed'),
                        ),
                      );
                      debugPrint(e.toString());
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Remove'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
