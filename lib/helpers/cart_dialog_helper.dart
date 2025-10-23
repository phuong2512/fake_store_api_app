import 'package:fake_store_api_app/views/cart/cart_controller.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:flutter/material.dart';

class CartDialogHelper {
  static void showOrderDialog(BuildContext context, bool isOrderSuccessful) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
      ),
    );
  }

  static void showCartOptions(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController,
  ) {
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
                    showEditDialog(context, cartProduct, cartController);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Remove'),
                  onTap: () {
                    Navigator.pop(context);
                    showRemoveDialog(context, cartProduct, cartController);
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
    CartController cartController,
  ) {
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
                      await cartController.updateQuantity(
                        cartProduct.product,
                        newQuantity,
                      );
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

  static void showRemoveDialog(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController,
  ) {
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
                      await cartController.removeFromCart(cartProduct.product);
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
