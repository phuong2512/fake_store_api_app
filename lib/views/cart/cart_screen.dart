import 'package:fake_store_api_app/models/product.dart';
import 'package:fake_store_api_app/models/rating.dart';
import 'package:fake_store_api_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demoCartList = [
      Product(
        id: 1,
        title: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
        price: 109.95,
        description:
            'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday',
        category: 'men\'s clothing',
        image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png',
        rating: Rating(rate: 3.9, count: 120),
      ),
      Product(
        id: 3,
        title: 'Mens Cotton Jacket',
        price: 55.99,
        description:
            'great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day.',
        category: 'men\'s clothing',
        image: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_t.png',
        rating: Rating(rate: 4.7, count: 500),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_fake_store.png',
                      width: 85,
                      height: 85,
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Demo Store',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: demoCartList.length,
                      itemBuilder: (context, index) {
                        final product = demoCartList[index];
                        return Column(
                          children: [
                            CartItem(product: product),
                            Divider(color: Colors.grey[400]),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Total: 165.94 \$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), //all product.price * quantity
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('ORDER'),
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
