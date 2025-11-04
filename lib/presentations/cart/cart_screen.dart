import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/helpers/cart_dialog_helper.dart';
import 'package:fake_store_api_app/presentations/widgets/cart_item.dart';
import 'package:fake_store_api_app/presentations/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleBar(),
              Expanded(
                child: StreamBuilder<CartState>(
                  stream: cartController.state,
                  initialData: cartController.currentState,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Initializing...'),
                          ],
                        ),
                      );
                    }

                    final state = snapshot.data!;

                    if (state.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Loading cart...'),
                          ],
                        ),
                      );
                    }
                    final cartProducts = state.cartProducts;

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
                            SizedBox(height: 10),
                            Text(
                              'Cart is empty',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = cartProducts[index];
                          return CartItem(
                            cartProduct: product,
                            onUpdate: () {
                              setState(() {});
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              StreamBuilder<CartState>(
                stream: cartController.state,
                initialData: cartController.currentState,
                builder: (context, snapshot) {
                  final state = snapshot.data!;
                  final cartProducts = state.cartProducts;
                  final totalPrice = state.totalPrice;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total: ${totalPrice.toStringAsFixed(2)} \$',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );

                          final isOrderSuccessful = await cartController
                              .placeOrder();

                          if (!context.mounted) return;

                          if (isOrderSuccessful) {
                            await CartDialogHelper.showOrderDialog(
                              context,
                              isOrderSuccessful,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            CartDialogHelper.showOrderDialog(
                              context,
                              isOrderSuccessful,
                            );
                          }
                        },
                        child: Text(
                          'ORDER',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
