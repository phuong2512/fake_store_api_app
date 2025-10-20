import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/helpers/cart_dialog_helper.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:fake_store_api_app/views/detail_product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final CartProduct cartProduct;

  const CartItem({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();
    final product = cartProduct.product;
    final quantity = cartProduct.quantity;

    return Column(
      children: [
        GestureDetector(
          onLongPress: () => CartDialogHelper.showCartOptions(
            context,
            cartProduct,
            cartController,
          ),
          onTap: () {
            final cartController = context.read<CartController>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (newContext) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: cartController),
                    ChangeNotifierProvider(
                      create: (context) => QuantityProvider(),
                    ),
                  ],
                  child: ProductDetailScreen(product: product),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
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
                              "${product.price}\$/pc",
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
        ),
      ],
    );
  }
}
