import 'package:flutter/material.dart';
import 'package:pos/common/convert/currency.dart';
import 'package:pos/common/style/color.dart';
import 'package:pos/feature/home/home_screen.dart';
import 'package:pos/feature/product/product_screen.dart';
import 'package:pos/main.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';

class AddNewProductScreen extends StatefulWidget {
  AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  bool _addingNew = false;

  final _formKey = GlobalKey<FormState>();

  String _name = "";

  String _price = "";

  String _stock = "";

  void _resetForm() {
    _formKey.currentState?.reset();
    _name = "";
    _price = "";
    _stock = "";
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk Baru'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Card(
        borderOnForeground: true,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nama Produk",
                    labelStyle: TextStyle(color: AppColors.onBackground),
                  ),
                  onChanged: (v) => _name = v.trim(),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter name" : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Harga",
                    labelStyle: TextStyle(color: AppColors.onBackground),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _price = v.trim(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter price";
                    if (double.tryParse(v) == null) return "Invalid price";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Total Stok",
                    labelStyle: TextStyle(color: AppColors.onBackground),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _stock = v.trim(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter stock";
                    if (int.tryParse(v) == null) return "Invalid stock";
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final product = Product(
                            name: _name,
                            price: double.parse(_price),
                            stock: int.parse(_stock),
                          );
                          await appState.addProduct(product);
                          setState(() {
                            _addingNew = false;
                            _resetForm();
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Tambah Produk Baru"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
