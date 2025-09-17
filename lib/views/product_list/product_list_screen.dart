import 'dart:convert';

import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/views/cart/cart_screen.dart';
import 'package:fake_store_api_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    _products = _fetchProducts();
    super.initState();
  }

  Future<List<Product>> _fetchProducts() async {
    final String response = await rootBundle.loadString(
      'assets/data/demo_products.json',
    );
    final List<dynamic> data = await json.decode(response);
    return data.map((e) => Product.fromJson(e)).toList();
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
                  child: FutureBuilder(
                    future: _products,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Product found"));
                      }
                      final products = snapshot.data!;
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Column(
                            children: [
                              ProductItem(product: product),
                              Divider(color: Colors.grey[400]),
                            ],
                          );
                        },
                      );
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
