import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quantity = context.watch<QuantityProvider>().quantity;
    final cartController = context.read<CartController>();
    var product = widget.product;
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
              Column(
                children: [
                  Image.network(product.image, height: 200, width: 200),
                  SizedBox(height: 20),
                  Align(
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                product.description,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Specifications'),
                            Text(
                              'Category',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(product.category),
                            Text(
                              'Rating',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${product.rating.rate}★ (${product.rating.count})',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Fake Store Demo App',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: DropdownButton<int>(
                                underline: SizedBox(),
                                isExpanded: true,
                                value: quantity,
                                items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem(
                                    value: index + 1,
                                    child: Text((index + 1).toString()),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<QuantityProvider>()
                                        .setQuantity(value);
                                  }
                                },
                              ),
                            ),
                            Text(
                              '${(product.price * quantity).toStringAsFixed(1)} \$',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 32,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                try {
                                  cartController.addToCart(product, quantity);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Product added to cart successfully',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Product added to cart failed',
                                      ),
                                    ),
                                  );
                                  debugPrint(e.toString());
                                }
                              },
                              child: Text(
                                'ADD TO \nCART',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
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
