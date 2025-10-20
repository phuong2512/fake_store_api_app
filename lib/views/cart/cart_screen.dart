import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/helpers/cart_dialog_helper.dart';
import 'package:fake_store_api_app/widgets/cart_item.dart';
import 'package:fake_store_api_app/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final cartProducts = cartController.cartProducts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleBar(),
              Expanded(
                child: cartProducts.isNotEmpty
                    ? Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              final product = cartProducts[index];
                              return CartItem(
                                cartProduct: product,
                              );
                            },
                          ),
                        ),
                      )
                    : cartController.isLoading == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Loading...'),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Cart is empty',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total: ${cartController.totalPrice.toStringAsFixed(2)} \$',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (cartProducts.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cart is empty')),
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                      final isOrderSuccessful = await cartController
                          .placeOrder();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      if (isOrderSuccessful == true && context.mounted) {
                        Navigator.pop(context);
                        CartDialogHelper.showOrderDialog(
                          context,
                          isOrderSuccessful,
                        );
                      } else {
                        CartDialogHelper.showOrderDialog(
                          context,
                          isOrderSuccessful,
                        );
                      }
                    },
                    child: Text('ORDER', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
