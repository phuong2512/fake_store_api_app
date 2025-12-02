import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/locator.dart';
import 'presentations/auth/login_controller.dart';
import 'presentations/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(const FakeStoreApp());
}

class FakeStoreApp extends StatelessWidget {
  const FakeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<LoginController>(
      create: (_) => getIt<LoginController>(),
      dispose: (_, controller) => controller.dispose(),
      child: MaterialApp(
        title: 'Fake Store App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const BeveledRectangleBorder(),
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
