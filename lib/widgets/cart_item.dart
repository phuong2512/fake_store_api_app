import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/views/detail_product/detail_product_screen.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Product product;

  const CartItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailProductScreen(product: product),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(product.image, width: 65, height: 65),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '1 pc',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "${product.price} \$/pc",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
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
    );
  }
}
