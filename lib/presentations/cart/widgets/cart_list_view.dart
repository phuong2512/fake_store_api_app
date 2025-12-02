import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/presentations/cart/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class CartListView extends StatelessWidget {
  final List<CartProductModel> cartProducts;

  const CartListView({super.key, required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    if (cartProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            Text(
              'Cart is empty',
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartProducts.length,
      itemBuilder: (context, index) {
        return CartItem(cartProduct: cartProducts[index]);
      },
    );
  }
}
