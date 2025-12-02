import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/widgets/title_bar.dart';
import 'package:fake_store_api_app/presentations/auth/login_screen.dart';
import 'package:fake_store_api_app/presentations/cart/cart_screen.dart';
import 'package:fake_store_api_app/presentations/product/product_detail/product_detail_screen.dart';
import 'package:fake_store_api_app/presentations/product/product_list/product_list_controller.dart';
import 'package:fake_store_api_app/presentations/product/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = getIt<ProductListController>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.fetchProducts();
        });
        return controller;
      },
      child: _ProductListContent(),
    );
  }
}

class _ProductListContent extends StatefulWidget {
  @override
  State<_ProductListContent> createState() => _ProductListContentState();
}

class _ProductListContentState extends State<_ProductListContent> {
  late final _controller = context.read<ProductListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _controller.logOut();
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
                    stream: _controller.loadingStream,
                    initialData: _controller.isLoading,
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

                      return StreamBuilder<List<ProductModel>>(
                        stream: _controller.productsStream,
                        initialData: _controller.products,
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
