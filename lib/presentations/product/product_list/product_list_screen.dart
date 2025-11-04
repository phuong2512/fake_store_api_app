import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/presentations/auth/auth_controller.dart';
import 'package:fake_store_api_app/presentations/auth/login_screen.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/cart/cart_screen.dart';
import 'package:fake_store_api_app/presentations/product/product_controller.dart';
import 'package:fake_store_api_app/presentations/widgets/product_item.dart';
import 'package:fake_store_api_app/presentations/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductController _productController;
  late final CartController _cartController;

  @override
  void initState() {
    super.initState();

    _productController = getIt<ProductController>();
    _cartController = getIt<CartController>();

    final authController = context.read<AuthController>();
    final userId = authController.currentUser?.id;

    _productController.fetchProducts();

    if (userId != null) {
      _cartController.getCart(userId);
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    _cartController.dispose();
    super.dispose();
  }

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
        Provider<ProductController>.value(value: _productController),
        Provider<CartController>.value(value: _cartController),
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
                    child: StreamBuilder<ProductState>(
                      stream: _productController.state,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final state = snapshot.data!;

                        if (state.isLoading) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Loading products...'),
                              ],
                            ),
                          );
                        }

                        if (state.error != null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Error: ${state.error}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }

                        final products = state.products;

                        if (products.isEmpty) {
                          return const Center(child: Text('No products found'));
                        }

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItem(product: product);
                          },
                        );
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
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Provider<CartController>.value(
                              value: _cartController,
                              child: const CartScreen(),
                            ),
                          ),
                        );
                      },
                      icon: SvgPicture.asset('assets/images/cart.svg'),
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
