import 'package:fake_store_api_app/views/product_list/product_list_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_fake_store.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 50),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        contentPadding: EdgeInsets.only(bottom: -15),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding: EdgeInsets.only(bottom: -15),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductListScreen(),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Fake Store Demo App',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
