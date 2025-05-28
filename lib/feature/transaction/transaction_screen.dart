import 'package:flutter/material.dart';
import 'package:pos/common/style/color.dart';
import 'package:pos/database/database.dart';
import 'package:pos/feature/transaction/histori_transaction_screen.dart';
import 'package:provider/provider.dart';

import '../../common/convert/currency.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String _selectedType = 'sale';
  int? _selectedProductId;
  String _quantityStr = '';
  String _amountStr = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Theme.of(context);
    final productItems = appState.products
        .map(
          (p) => DropdownMenuItem<int>(
            value: p.id,
            child: Text("${p.name} (\ ${formatRupiah(p.price)})"),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(value: 'sale', child: Text('Sale')),
                        DropdownMenuItem(
                          value: 'outcome',
                          child: Text('Outcome'),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedType = val ?? 'sale';
                          _selectedProductId = null;
                          _quantityStr = '';
                          _amountStr = '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType == 'sale')
                      DropdownButtonFormField<int>(
                        value: _selectedProductId,
                        decoration: const InputDecoration(
                          labelText: "Product",
                          labelStyle: TextStyle(color: AppColors.onBackground),
                        ),
                        items: productItems,
                        onChanged: (val) =>
                            setState(() => _selectedProductId = val),
                        validator: (v) => v == null && _selectedType == 'sale'
                            ? 'Select product'
                            : null,
                      ),
                    if (_selectedType == 'sale') const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: AppColors.onBackground),
                        labelText: _selectedType == 'sale'
                            ? 'Quantity'
                            : 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          if (_selectedType == 'sale') {
                            _quantityStr = val;
                          } else {
                            _amountStr = val;
                          }
                        });
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Required";
                        if (_selectedType == 'sale') {
                          final v = int.tryParse(val);
                          if (v == null || v <= 0) return "Invalid quantity";
                          if (_selectedProductId != null) {
                            final prod = appState.products.firstWhere(
                              (p) => p.id == _selectedProductId,
                            );
                            if (v > prod.stock) {
                              return "Not enough stock (${prod.stock})";
                            }
                          }
                        } else {
                          final v = double.tryParse(val);
                          if (v == null || v <= 0) return "Invalid amount";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType == 'sale')
                      Builder(
                        builder: (context) {
                          if (_selectedProductId == null) {
                            return const Text("-");
                          }
                          final p = appState.products.firstWhere(
                            (p) => p.id == _selectedProductId,
                          );
                          final qty = double.tryParse(_quantityStr) ?? 0;
                          final total = p.price * qty;
                          return Text("Total: ${formatRupiah(total)}");
                        },
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedType == 'sale' &&
                              _selectedProductId != null) {
                            final qty = int.parse(_quantityStr);
                            final product = appState.products.firstWhere(
                              (p) => p.id == _selectedProductId,
                            );
                            product.stock -= qty;
                            await appState.updateProduct(product);
                            final amount = product.price * qty;
                            await appState.addTransaction(
                              Transaction(
                                productId: _selectedProductId,
                                type: 'sale',
                                quantity: qty,
                                amount: amount,
                                date: DateTime.now().toIso8601String(),
                              ),
                            );
                          } else if (_selectedType == 'outcome') {
                            final amt = double.parse(_amountStr);
                            await appState.addTransaction(
                              Transaction(
                                type: 'outcome',
                                amount: amt,
                                date: DateTime.now().toIso8601String(),
                              ),
                            );
                          }
                          setState(() {
                            _selectedProductId = null;
                            _quantityStr = '';
                            _amountStr = '';
                          });
                          _formKey.currentState!.reset();
                        }
                      },
                      child: const Text("Record"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
          FilledButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriTransactionScreen(),
                ),
              );
            },
            child: const Text("Lihat Detail Histori Transaksi"),
          ),
        ],
      ),
    );
  }
}
