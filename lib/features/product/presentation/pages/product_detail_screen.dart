import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fake_store_api_app/presentations/shared_widgets/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_detail_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int userId;
  final int? cartId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.userId,
    required this.cartId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailController _controller;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _controller = getIt<ProductDetailController>();

    // Check if product is in cart
    _controller.checkProductInCart(widget.userId, widget.product.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    final success = await _controller.addToCart(
      cartId: widget.cartId,
      productId: widget.product.id,
      quantity: _quantity,
      userId: widget.userId,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add product to cart'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ProductDetailController>.value(
      value: _controller,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const TitleBar(),
              const SizedBox(height: 10),
              Image.network(widget.product.image, height: 200, width: 200),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.product.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Specifications'),
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
                                dropdownStyleData: const DropdownStyleData(
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
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 32,
                            ),
                          ),
                          StreamBuilder<bool>(
                            stream: _controller.addingStream,
                            initialData: _controller.isAdding,
                            builder: (context, addingSnapshot) {
                              final isAdding = addingSnapshot.data ?? false;

                              return StreamBuilder<bool>(
                                stream: _controller.isInCartStream,
                                initialData: _controller.isInCart,
                                builder: (context, inCartSnapshot) {
                                  final isInCart = inCartSnapshot.data ?? false;

                                  return ElevatedButton(
                                    onPressed: isAdding ? null : _addToCart,
                                    child: isAdding
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Text(
                                            isInCart
                                                ? 'ADD MORE \nTO CART'
                                                : 'ADD TO \nCART',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                  );
                                },
                              );
                            },
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
      ),
    );
  }
}
