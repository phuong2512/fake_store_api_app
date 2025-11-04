import 'package:fake_store_api_app/data/models/cart_product.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:flutter/material.dart';

class CartDialogHelper {
  static Future<void> showOrderDialog(
      BuildContext context, bool isOrderSuccessful) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isOrderSuccessful ? 'Order Successful' : 'Order Failed',
          textAlign: TextAlign.center,
        ),
        content: Text(
          isOrderSuccessful
              ? 'Your orders have been placed successfully!'
              : 'Your orders have been placed failed!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showCartOptions(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController, {
    VoidCallback? onUpdate,
  }) {
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
                    showEditDialog(
                      context,
                      cartProduct,
                      cartController,
                      onUpdate: onUpdate,
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove'),
                  onTap: () {
                    Navigator.pop(context);
                    showRemoveDialog(
                      context,
                      cartProduct,
                      cartController,
                      onUpdate: onUpdate,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showEditDialog(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController, {
    VoidCallback? onUpdate,
  }) {
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final newQuantityStr = quantityTextController.text.trim();
                    final newQuantity = int.tryParse(newQuantityStr);

                    if (newQuantity == null || newQuantity <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter a valid quantity'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      await cartController.updateQuantity(
                        cartProduct.product,
                        newQuantity,
                      );

                      if (!context.mounted) return;

                      Navigator.pop(context);
                      onUpdate?.call();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Product's quantity updated"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Product's quantity update failed"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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

  static void showRemoveDialog(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController, {
    VoidCallback? onUpdate,
  }) {
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await cartController.removeFromCart(cartProduct.product);

                      if (!context.mounted) return;

                      Navigator.pop(context);
                      onUpdate?.call();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product removed from cart'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product removed from cart failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
