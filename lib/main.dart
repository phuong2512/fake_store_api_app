import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/services/cart_service.dart';
import 'package:fake_store_api_app/services/product_service.dart';
import 'package:fake_store_api_app/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<ProductService>(() => ProductService());
  getIt.registerLazySingleton<CartService>(() => CartService());
  getIt.registerLazySingleton<ProductController>(
    () => ProductController(getIt<ProductService>()),
  );
  getIt.registerLazySingleton<CartController>(
    () => CartController(getIt<CartService>()),
  );
}

void main() {
  setupGetIt();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ProductController>()),
        ChangeNotifierProvider(create: (_) => getIt<CartController>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
