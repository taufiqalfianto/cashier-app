import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos/common/widget/button_widget.dart';
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
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/cashier-ilustration.png'),
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
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16.h),

                    Text(
                      "Selamat Datang Kembali",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.onBackground,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (v) => _username = v.trim(),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Please enter username'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (v) => _password = v,
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Please enter password'
                          : null,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _tryLogin(),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : ButtonWidget(title: 'Login', onPressed: _tryLogin),
                    ),
                  ],
                ),
              ),
            ],
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
