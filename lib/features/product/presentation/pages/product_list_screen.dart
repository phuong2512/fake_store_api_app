import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:fake_store_api_app/features/auth/presentation/pages/login_screen.dart';
import 'package:fake_store_api_app/features/cart/presentation/controller/cart_controller.dart';
import 'package:fake_store_api_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_controller.dart';
import 'package:fake_store_api_app/features/product/presentation/pages/product_detail_screen.dart';
import 'package:fake_store_api_app/features/product/presentation/widgets/product_item.dart';
import 'package:fake_store_api_app/presentations/shared_widgets/widgets/title_bar.dart';
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


    _cartController.reset();

    // Logout
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

                // Product list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: StreamBuilder<bool>(
                      stream: _productController.loadingStream,
                      initialData: _productController.isLoading,
                      builder: (context, loadingSnapshot) {
                        final isLoading = loadingSnapshot.data ?? false;

                        if (isLoading) {
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

                        return StreamBuilder<List<Product>>(
                          stream: _productController.productsStream,
                          initialData: _productController.products,
                          builder: (context, productsSnapshot) {
                            final products = productsSnapshot.data ?? [];

                            if (products.isEmpty) {
                              return const Center(
                                child: Text('No products found'),
                              );
                            }

                            return ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final cartController = context
                                    .watch<CartController>();
                                final authController = context
                                    .read<AuthController>();
                                final bool isInCart = cartController
                                    .isProductInCart(product);
                                return ProductItem(
                                  product: product,
                                  isProductInCart: isInCart,
                                  onTap: () {
                                    final userId =
                                        authController.currentUser?.id;
                                    if (userId == null) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          product: product,
                                          userId: userId,
                                          isProductInCart: isInCart,
                                          onAddToCart: (quantity) async {
                                            await cartController.addToCart(
                                              product,
                                              quantity,
                                              userId,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
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
