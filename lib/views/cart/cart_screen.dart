import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/widgets/cart_item.dart';
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
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_fake_store.png',
                      width: 85,
                      height: 85,
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Demo Store',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                cartController: cartController,
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
                      final isOrderSuccessful = await cartController.placeOrder();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      if (!context.mounted) return;
                      cartController.showOrderDialog(
                        context,
                        isOrderSuccessful,
                      );
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
