import 'package:fake_store_api_app/presentations/auth/login_controller.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.controller,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: controller.loadingStream,
      initialData: controller.isLoading,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;

        return Column(
          children: [
            TextField(
              controller: usernameController,
              enabled: !isLoading,
              decoration: const InputDecoration(
                hintText: 'Username',
                contentPadding: EdgeInsets.only(bottom: -15),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: passwordController,
              obscureText: true,
              enabled: !isLoading,
              decoration: const InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.only(bottom: -15),
              ),
            ),
          ],
        );
      },
    );
  }
}
