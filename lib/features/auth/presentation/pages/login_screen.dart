import 'package:fake_store_api_app/features/auth/domain/entities/user.dart';
import 'package:fake_store_api_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:fake_store_api_app/features/product/presentation/pages/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authController = context.read<AuthController>();

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    await authController.login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
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
                    const SizedBox(height: 50),

                    // Lắng nghe loading state để disable/enable input
                    StreamBuilder<bool>(
                      stream: authController.loadingStream,
                      initialData: authController.isLoading,
                      builder: (context, snapshot) {
                        final isLoading = snapshot.data ?? false;

                        return Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              enabled: !isLoading,
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                contentPadding: EdgeInsets.only(bottom: -15),
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              controller: _passwordController,
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
                    ),

                    const SizedBox(height: 50),

                    // Button với loading indicator
                    StreamBuilder<bool>(
                      stream: authController.loadingStream,
                      initialData: authController.isLoading,
                      builder: (context, snapshot) {
                        final isLoading = snapshot.data ?? false;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.black),
                                ),
                        );
                      },
                    ),
                  ],
                ),

                // Lắng nghe token để navigate
                StreamBuilder<String?>(
                  stream: authController.tokenStream,
                  builder: (context, tokenSnapshot) {
                    return StreamBuilder<User?>(
                      stream: authController.userStream,
                      builder: (context, userSnapshot) {
                        if (tokenSnapshot.hasData &&
                            tokenSnapshot.data != null &&
                            userSnapshot.hasData &&
                            userSnapshot.data != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductListScreen(),
                                ),
                              );
                              _usernameController.clear();
                              _passwordController.clear();
                            }
                          });
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),

                const Text(
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
