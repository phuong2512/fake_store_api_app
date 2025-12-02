import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/cart/helper/cart_dialog_helper.dart';
import 'package:flutter/material.dart';

class CartBottomTotalBar extends StatelessWidget {
  final CartController controller;

  const CartBottomTotalBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: controller.totalPriceStream,
      initialData: 0.0,
      builder: (context, priceSnapshot) {
        final totalPrice = priceSnapshot.data ?? 0.0;

        return StreamBuilder<List<CartProductModel>>(
          stream: controller.cartProductsStream,
          initialData: controller.cartProducts,
          builder: (context, productsSnapshot) {
            final cartProducts = productsSnapshot.data ?? [];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Total: ${totalPrice.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _handleOrder(context, controller, cartProducts),
                  child: const Text(
                    'ORDER',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleOrder(
    BuildContext context,
    CartController controller,
    List<CartProductModel> products,
  ) async {
    if (products.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final isSuccess = await controller.placeOrder();

    if (!context.mounted) return;
    Navigator.pop(context);

    await CartDialogHelper.showOrderDialog(context, isSuccess);

    if (isSuccess && context.mounted) {
      Navigator.pop(context);
    }
  }
}
