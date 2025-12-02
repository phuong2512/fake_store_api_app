import 'package:fake_store_api_app/core/di/locator.dart';
import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/presentations/auth/login_controller.dart';
import 'package:fake_store_api_app/presentations/auth/widgets/login_button.dart';
import 'package:fake_store_api_app/presentations/auth/widgets/login_form.dart';
import 'package:fake_store_api_app/presentations/product/product_list/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<LoginController>(),
      child: _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _loginController = context.read<LoginController>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    await _loginController.login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
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

                    LoginForm(
                      controller: _loginController,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                    ),

                    const SizedBox(height: 50),

                    LoginButton(
                      controller: _loginController,
                      onLogin: _handleLogin,
                    ),
                  ],
                ),

                StreamBuilder<String?>(
                  stream: _loginController.tokenStream,
                  builder: (context, tokenSnapshot) {
                    return StreamBuilder<UserModel?>(
                      stream: _loginController.userStream,
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
