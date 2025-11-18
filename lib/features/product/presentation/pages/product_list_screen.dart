import 'package:fake_store_api_app/features/auth/presentation/pages/login_screen.dart';
import 'package:fake_store_api_app/presentations/shared_widgets/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_list_controller.dart';
import 'package:fake_store_api_app/features/product/presentation/widgets/product_item.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        final controller = getIt<ProductListController>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.fetchProducts();
        });
        return controller;
      },
      dispose: (_, controller) => controller.dispose(),
      child: ProductListContent(),
    );
  }
}

class ProductListContent extends StatelessWidget {
  const ProductListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProductListController>();
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              controller.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            },
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
                  child: StreamBuilder<bool>(
                    stream: controller.loadingStream,
                    initialData: controller.isLoading,
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
                        stream: controller.productsStream,
                        initialData: controller.products,
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
                              return ProductItem(
                                product: product,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailScreen(product: product),
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
                        MaterialPageRoute(builder: (_) => const CartScreen()),
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
    );
  }
}
