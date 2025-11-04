import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fake_store_api_app/data/models/product.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int userId;
  final bool isProductInCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.userId,
    required this.isProductInCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addToCart() async {
    if (_isAdding) return;

    setState(() {
      _isAdding = true;
    });

    try {
      final cartController = context.read<CartController>();

      await cartController.addToCart(widget.product, _quantity, widget.userId);

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleBar(),
            const SizedBox(height: 10),
            Image.network(widget.product.image, height: 200, width: 200),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.product.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              value: _quantity,
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down),
                              ),
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 5),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 80,
                              ),
                              items: List.generate(
                                10,
                                (index) => DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _quantity = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          '${(widget.product.price * _quantity).toStringAsFixed(2)} \$',
                          style: TextStyle(color: Colors.green, fontSize: 32),
                        ),
                        ElevatedButton(
                          onPressed: _isAdding ? null : _addToCart,
                          child: _isAdding
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  widget.isProductInCart
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
