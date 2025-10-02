import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:fake_store_api_app/widgets/title_bar.dart';
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
    final product = widget.product;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleBar(),
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
                              child: DropdownMenu<int>(
                                menuHeight: 100,
                                initialSelection: quantity,
                                dropdownMenuEntries: List.generate(
                                  5,
                                  (index) => DropdownMenuEntry<int>(
                                    value: index + 1,
                                    label: (index + 1).toString(),
                                  ),
                                ),
                                onSelected: (value) {
                                  if (value != null) {
                                    context
                                        .read<QuantityProvider>()
                                        .setQuantity(value);
                                  }
                                },
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                      border: InputBorder.none,
                                    ),
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
                              child:
                                  cartController.isProductInCart(product) ==
                                      false
                                  ? Text(
                                      'ADD TO \nCART',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      'ADD MORE \nTO CART',
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
