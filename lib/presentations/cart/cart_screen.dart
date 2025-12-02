import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/core/models/cart_product.dart';
import 'package:fake_store_api_app/core/widgets/title_bar.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/cart/widgets/cart_bottom_total_bar.dart';
import 'package:fake_store_api_app/presentations/cart/widgets/cart_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CartController>(),
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
  late final _cartController = context.read<CartController>();

  @override
  void initState() {
    super.initState();
    _cartController.loadCart();
  }

  @override
  Widget build(BuildContext context) {
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
                    stream: _cartController.loadingStream,
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

                      return StreamBuilder<List<CartProductModel>>(
                        stream: _cartController.cartProductsStream,
                        initialData: _cartController.cartProducts,
                        builder: (context, snapshot) {
                          return CartListView(
                            cartProducts: snapshot.data ?? [],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              CartBottomTotalBar(controller: _cartController),
            ],
          ),
        ),
      ),
    );
  }
}
