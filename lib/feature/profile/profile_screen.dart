import 'package:flutter/material.dart';
import 'package:pos/database/database.dart';
import 'package:provider/provider.dart';

import '../../common/style/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    _username = appState.username ?? "";
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Profile"),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (v) => _username = v.trim(),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter username" : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await appState.changeUsername(_username);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Username updated")),
                          );
                        }
                      }
                    },
                    child: const Text("Update Profile"),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(AppColors.error),
                    ),
                    onPressed: () => appState.logout(),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
