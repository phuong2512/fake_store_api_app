import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/core/widgets/title_bar.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        final controller = getIt<ProductDetailController>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.checkProductInCart(product.id);
        });
        return controller;
      },
      dispose: (_, controller) => controller.dispose(),
      child: ProductDetailContent(product: product),
    );
  }
}

class ProductDetailContent extends StatefulWidget {
  final Product product;

  const ProductDetailContent({super.key, required this.product});

  @override
  State<ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  int _quantity = 1;

  Future<void> _addToCart() async {
    final controller = context.read<ProductDetailController>();

    final success = await controller.addToCart(
      productId: widget.product.id,
      quantity: _quantity,
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
    final controller = context.read<ProductDetailController>();

    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
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
                      ],
                    ),
                  ),

                  Flexible(
                    child: Column(
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
                              items: List.generate(
                                10,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text('${i + 1}'),
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
                          stream: controller.addingStream,
                          initialData: controller.isAdding,
                          builder: (context, addingSnapshot) {
                            final isAdding = addingSnapshot.data ?? false;

                            return StreamBuilder<bool>(
                              stream: controller.isInCartStream,
                              initialData: controller.isInCart,
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
    );
  }
}
