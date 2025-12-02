import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/presentations/product/product_detail/product_detail_controller.dart';
import 'package:flutter/material.dart';

class ProductDetailActions extends StatefulWidget {
  final ProductModel product;
  final ProductDetailController controller;
  final VoidCallback onAddToCart;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetailActions({
    super.key,
    required this.product,
    required this.controller,
    required this.onAddToCart,
    required this.onQuantityChanged,
  });

  @override
  State<ProductDetailActions> createState() => _ProductDetailActionsState();
}

class _ProductDetailActionsState extends State<ProductDetailActions> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Specifications Column
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Specifications'),
                _buildSpecItem('Category', widget.product.category),
                _buildSpecItem(
                  'Rating',
                  '${widget.product.rating.rate}★ (${widget.product.rating.count})',
                ),
              ],
            ),
          ),

          // Actions Column
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                          setState(() => _quantity = value);
                          widget.onQuantityChanged(value);
                        }
                      },
                    ),
                  ),
                ),
                Text(
                  '${(widget.product.price * _quantity).toStringAsFixed(2)} \$',
                  style: const TextStyle(color: Colors.green, fontSize: 32),
                ),

                // Add to Cart Button Logic
                StreamBuilder<bool>(
                  stream: widget.controller.addingStream,
                  initialData: widget.controller.isAdding,
                  builder: (context, addingSnapshot) {
                    final isAdding = addingSnapshot.data ?? false;
                    return StreamBuilder<bool>(
                      stream: widget.controller.isInCartStream,
                      initialData: widget.controller.isInCart,
                      builder: (context, inCartSnapshot) {
                        final isInCart = inCartSnapshot.data ?? false;
                        return ElevatedButton(
                          onPressed: isAdding ? null : widget.onAddToCart,
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
                                  style: const TextStyle(color: Colors.black),
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
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value),
      ],
    );
  }
}
