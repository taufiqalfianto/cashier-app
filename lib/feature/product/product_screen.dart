import 'package:flutter/material.dart';
import 'package:pos/common/convert/currency.dart';
import 'package:pos/common/style/color.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: appState.products.isEmpty
                ? Center(child: Text("No products yet"))
                : ListView.builder(
                    itemCount: appState.products.length,
                    itemBuilder: (context, index) {
                      final p = appState.products[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          title: Text(
                            "Nama Produk: ${p.name}\nHarga: ${formatRupiah(p.price)}\nStok: ${p.stock}",
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              AppColors.primary,
                                            ),
                                      ),
                                      onPressed: () async {
                                        if (p.stock > 0) {
                                          p.stock--;
                                          await appState.updateProduct(p);
                                        }
                                      },
                                      child: Text('Tambah Stok'),
                                    ),
                                    FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              AppColors.primary,
                                            ),
                                      ),
                                      onPressed: () async {
                                        if (p.stock > 0) {
                                          p.stock--;
                                          await appState.updateProduct(p);
                                        }
                                      },
                                      child: Text('Kurang Stok'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      AppColors.error,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Center(
                                          child: const Text(
                                            "Yakin Hapus Produk",
                                          ),
                                        ),
                                        content: Text(
                                          "Hapus Produk'${p.name}'?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              "Hapus",
                                              style: TextStyle(
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await appState.removeProduct(p.id!);
                                    }
                                  },
                                  child: Text('Hapus Produk'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
