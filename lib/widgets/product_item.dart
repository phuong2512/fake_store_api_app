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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => QuantityProvider(),
            child: DetailProductScreen(product: product),
          ),
        ),
      ),
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
                        Text(
                          product.category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "${product.rating.rate}★",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "${product.price} \$",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
