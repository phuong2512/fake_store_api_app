import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/di/locator.dart';
import 'package:fake_store_api_app/repositories/auth_repository.dart';
import 'package:fake_store_api_app/repositories/cart_repository.dart';
import 'package:fake_store_api_app/repositories/product_repository.dart';
import 'package:fake_store_api_app/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupGetIt();
  runApp(const FakeStoreApp());
}

class FakeStoreApp extends StatelessWidget {
  const FakeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(getIt<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductController(getIt<ProductRepository>()),
        ),
        ChangeNotifierProvider(
          create: (_) => CartController(getIt<CartRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: BeveledRectangleBorder(),
              backgroundColor: Colors.grey[350],
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
