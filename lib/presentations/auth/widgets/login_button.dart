import 'package:fake_store_api_app/presentations/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginButton({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LoginController>();

    return StreamBuilder<bool>(
      stream: controller.loadingStream,
      initialData: controller.isLoading,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;

        return ElevatedButton(
          onPressed: isLoading ? null : onLogin,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text('LOGIN', style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
