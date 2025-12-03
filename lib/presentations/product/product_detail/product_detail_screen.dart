import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/widgets/title_bar.dart';
import 'package:fake_store_api_app/presentations/product/product_detail/product_detail_controller.dart';
import 'package:fake_store_api_app/presentations/product/widgets/product_detail_actions.dart';
import 'package:fake_store_api_app/presentations/product/widgets/product_detail_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = getIt<ProductDetailController>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.checkProductInCart(product.id);
        });
        return controller;
      },
      child: ProductDetailContent(product: product),
    );
  }
}

class ProductDetailContent extends StatefulWidget {
  final ProductModel product;

  const ProductDetailContent({super.key, required this.product});

  @override
  State<ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  int _currentQuantity = 1;
  late final _controller = context.read<ProductDetailController>();

  Future<void> _addToCart() async {
    final success = await _controller.addToCart(
      productId: widget.product.id,
      quantity: _currentQuantity,
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TitleBar(),
            const SizedBox(height: 10),
            Expanded(child: ProductDetailInfo(product: widget.product)),

            ProductDetailActions(
              product: widget.product,
              controller: _controller,
              onQuantityChanged: (quantity) => _currentQuantity = quantity,
              onAddToCart: _addToCart,
            ),
          ],
        ),
      ),
    );
  }
}
