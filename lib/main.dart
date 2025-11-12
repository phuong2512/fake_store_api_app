import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:fake_store_api_app/features/auth/presentation/pages/login_screen.dart';
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
    return Provider<AuthController>(
      create: (_) => getIt<AuthController>(),
      dispose: (_, controller) => controller.dispose(),
      child: MaterialApp(
        title: 'Fake Store App',
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
