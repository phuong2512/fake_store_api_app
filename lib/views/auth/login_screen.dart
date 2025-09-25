import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/views/product_list/product_list_screen.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final authController = context.read<AuthController>();

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await authController.login(
        _usernameController.text,
        _passwordController.text,
      );
      if (authController.token != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        contentPadding: EdgeInsets.only(bottom: -15),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        contentPadding: EdgeInsets.only(bottom: -15),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ],
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
