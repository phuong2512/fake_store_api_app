import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_product.dart';
import 'package:fake_store_api_app/features/cart/presentation/controller/cart_controller.dart';
import 'package:fake_store_api_app/features/cart/presentation/helpers/cart_dialog_helper.dart';
import 'package:fake_store_api_app/features/cart/presentation/widgets/cart_item.dart';
import 'package:fake_store_api_app/presentations/shared_widgets/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => getIt<CartController>(),
      dispose: (_, controller) => controller.dispose(),
      child: CartScreenContent(),
    );
  }
}

class CartScreenContent extends StatefulWidget {
  const CartScreenContent({super.key});

  @override
  State<CartScreenContent> createState() => _CartScreenContentState();
}

class _CartScreenContentState extends State<CartScreenContent> {
  @override
  void initState() {
    super.initState();
    final cartController = context.read<CartController>();
    cartController.loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleBar(),
              Expanded(
                child: Center(
                  child: StreamBuilder<bool>(
                    stream: cartController.loadingStream,
                    builder: (context, loadingSnapshot) {
                      final isLoading = loadingSnapshot.data ?? true;

                      if (isLoading) {
                        return const Center(
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

                      return StreamBuilder<List<CartProduct>>(
                        stream: cartController.cartProductsStream,
                        initialData: cartController.cartProducts,
                        builder: (context, productsSnapshot) {
                          final cartProducts = productsSnapshot.data ?? [];

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
                                  const SizedBox(height: 10),
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

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              return CartItem(cartProduct: cartProducts[index]);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              StreamBuilder<double>(
                stream: cartController.totalPriceStream,
                builder: (context, priceSnapshot) {
                  final totalPrice = priceSnapshot.data ?? 0.0;

                  return StreamBuilder<List<CartProduct>>(
                    stream: cartController.cartProductsStream,
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
                            onPressed: () async {
                              if (cartProducts.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cart is empty'),
                                  ),
                                );
                                return;
                              }
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );

                              final isOrderSuccessful = await cartController
                                  .placeOrder();

                              if (!context.mounted) return;
                              Navigator.pop(context);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
