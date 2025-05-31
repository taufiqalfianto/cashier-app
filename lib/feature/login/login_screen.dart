import 'package:flutter/material.dart';
import 'package:pos/database/database.dart';
import 'package:provider/provider.dart';

import '../../common/style/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cashier-logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Cashier App',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome Back"),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (v) => _username = v.trim(),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter username' : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    onChanged: (v) => _password = v,
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter password' : null,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _tryLogin(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _tryLogin,
                            child: const Text('LOG IN'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _tryLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      Provider.of<AppState>(
        context,
        listen: false,
      ).login(_username, _password).then((_) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    }
  }
}
