import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:fake_store_api_app/views/detail_product/detail_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final CartProduct cartProduct;
  final CartController cartController;

  const CartItem({
    super.key,
    required this.cartProduct,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartProduct.product;
    final quantity = cartProduct.quantity;
    return Column(
      children: [
        GestureDetector(
          onLongPress: () =>
              cartController.showCartOptions(context, cartProduct),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => QuantityProvider(),
                child: DetailProductScreen(product: product),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(product.image, width: 65, height: 65),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Row(
                        children: [
                          Text(
                            '$quantity pc',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "${product.price} \$/pc",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey[400]),
      ],
    );
  }
}
