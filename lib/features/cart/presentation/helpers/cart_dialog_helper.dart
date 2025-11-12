import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';

class CartDialogHelper {
  static Future<void> showOrderDialog(
    BuildContext context,
    bool isOrderSuccessful,
  ) async {
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
            child: const Text('OK'),
          ),
        ],
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
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    showEditDialog(context, cartProduct, cartController);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Quantity', textAlign: TextAlign.center),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: quantityTextController,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final newQuantityStr = quantityTextController.text.trim();
                    final newQuantity = int.tryParse(newQuantityStr);

                    if (newQuantity == null || newQuantity <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product's quantity updated"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product's quantity update failed"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Product', textAlign: TextAlign.center),
          content: const Text(
            'Are you sure you want to remove this product from your cart?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await cartController.removeFromCart(cartProduct.product);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product removed from cart'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product removed from cart failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
