import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fake_store_api_app/views/auth/auth_controller.dart';
import 'package:fake_store_api_app/views/cart/cart_controller.dart';
import 'package:fake_store_api_app/views/cart/cart_repository.dart';
import 'package:fake_store_api_app/di/locator.dart';
import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:fake_store_api_app/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isCheckingCart = true;
  bool _isProductInCart = false;

  @override
  void initState() {
    super.initState();
    _checkIfProductInCart();
  }

  Future<void> _checkIfProductInCart() async {
    final userId = context.read<AuthController>().currentUser!.id;
    final cartRepository = getIt<CartRepository>();

    final inCart = await cartRepository.isProductInCart(
      userId,
      widget.product.id,
    );

    if (mounted) {
      setState(() {
        _isProductInCart = inCart;
        _isCheckingCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();
    final quantity = context.watch<QuantityProvider>().quantity;
    final userId = context.read<AuthController>().currentUser!.id;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            const SizedBox(height: 10),
            Image.network(widget.product.image, height: 200, width: 200),
            SizedBox(height: 10),
            Text(
              widget.product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.product.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        Text(widget.product.category),
                        Text(
                          'Rating',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${widget.product.rating.rate}★ (${widget.product.rating.count})',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Fake Store Demo App',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              value: quantity,
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down),
                              ),
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 5),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 100,
                                width: 80,
                              ),
                              items: List.generate(
                                5,
                                (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<QuantityProvider>().setQuantity(
                                    value,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          '${(widget.product.price * quantity).toStringAsFixed(1)} \$',
                          style: TextStyle(color: Colors.green, fontSize: 32),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await cartController.addToCart(
                                widget.product,
                                quantity,
                                userId,
                              );
                              if (!context.mounted) return;

                              setState(() {
                                _isProductInCart = true;
                              });

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Product added to cart successfully',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Product added to cart failed'),
                                ),
                              );
                              debugPrint(e.toString());
                            }
                          },
                          child: _isCheckingCart
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isProductInCart
                                      ? 'ADD MORE \nTO CART'
                                      : 'ADD TO \nCART',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
