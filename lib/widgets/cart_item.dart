import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/models/cart_product.dart';
import 'package:fake_store_api_app/views/detail_product/detail_product_screen.dart';
import 'package:flutter/material.dart';

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
          onLongPress: () => showOptions(context, cartProduct, cartController),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailProductScreen(product: product),
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

  void showOptions(
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
                  title: Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    showDeleteDialog(context, cartProduct, cartController);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditDialog(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController,
  ) {
    final quantity = cartProduct.quantity;
    final quantityTextController = TextEditingController(
      text: quantity.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityTextController,
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newQuantity = int.parse(quantityTextController.text);
                try {
                  cartController.updateQuantity(
                    cartProduct.product,
                    newQuantity,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product's quantity updated")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product's quantity update failed")),
                  );
                  debugPrint(e.toString());
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(
    BuildContext context,
    CartProduct cartProduct,
    CartController cartController,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  cartController.removeFromCart(cartProduct.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product removed from cart')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product removed from cart failed')),
                  );
                  debugPrint(e.toString());
                }
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
