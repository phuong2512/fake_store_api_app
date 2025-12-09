import 'package:fake_store_api_app/presentations/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();

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
