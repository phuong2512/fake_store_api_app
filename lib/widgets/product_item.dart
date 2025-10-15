import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/providers/quantity_provider.dart';
import 'package:fake_store_api_app/views/detail_product/detail_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cartController = context.read<CartController>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: cartController),
                ChangeNotifierProvider(create: (context) => QuantityProvider()),
              ],
              child: DetailProductScreen(product: product),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 15, top: 15),
                child: Image.network(product.image, width: 65, height: 65),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.category,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            "${product.rating.rate}★",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Text(
                            "${product.price} \$",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
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
