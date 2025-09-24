import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/views/cart/cart_screen.dart';
import 'package:fake_store_api_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().fetchProducts();
    });
    _getCart();
  }

  void _getCart() {
    final cartController = context.read<CartController>();
    final authController = context.read<AuthController>();
    final userId = authController.currentUser!.id;
    cartController.getCart(userId);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Consumer<ProductController>(
                    builder: (context, controller, child) {
                      if (controller.isLoading) {
                        return Center(
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
                          : Center(child: Text('No products found'));
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Fake Store Demo App',
                      style: TextStyle(color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      ),
                      icon: Icon(Icons.shopping_basket, size: 50),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
