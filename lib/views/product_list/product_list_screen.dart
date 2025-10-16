import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/di/locator.dart';
import 'package:fake_store_api_app/repositories/cart_repository.dart';
import 'package:fake_store_api_app/repositories/product_repository.dart';
import 'package:fake_store_api_app/views/auth/login_screen.dart';
import 'package:fake_store_api_app/views/cart/cart_screen.dart';
import 'package:fake_store_api_app/widgets/product_item.dart';
import 'package:fake_store_api_app/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _logout(BuildContext context) {
    final authController = context.read<AuthController>();
    authController.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (router) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ProductController(getIt<ProductRepository>())..fetchProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final authController = context.read<AuthController>();
            final userId = authController.currentUser?.id;
            final controller = CartController(getIt<CartRepository>());
            if (userId != null) {
              controller.getCart(userId);
            }
            return controller;
          },
        ),
      ],
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          child: Center(
            child: ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Consumer<ProductController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Loading...'),
                              ],
                            ),
                          );
                        }
                        final products = controller.products;
                        return products.isNotEmpty
                            ? ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return ProductItem(product: product);
                                },
                              )
                            : const Center(child: Text('No products found'));
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Fake Store Demo App',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Consumer<CartController>(
                      builder: (context, controller, child) {
                        return IconButton(
                          onPressed: () {
                            final cartController = context
                                .read<CartController>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) =>
                                    ChangeNotifierProvider.value(
                                      value: cartController,
                                      child: const CartScreen(),
                                    ),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/images/cart.svg',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
