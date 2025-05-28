import 'package:flutter/material.dart';
import 'package:pos/common/style/color.dart';
import 'package:pos/database/database.dart';
import 'package:provider/provider.dart';

import '../../common/convert/currency.dart';

class HistoriTransactionScreen extends StatefulWidget {
  const HistoriTransactionScreen({Key? key}) : super(key: key);
  @override
  State<HistoriTransactionScreen> createState() =>
      _HistoriTransactionScreenState();
}

class _HistoriTransactionScreenState extends State<HistoriTransactionScreen> {
  String _selectedType = 'sale';
  int? _selectedProductId;
  String _quantityStr = '';
  String _amountStr = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.onBackground),
          ),
          backgroundColor: AppColors.background,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Sale'),
              Tab(text: 'Outcome'),
            ],
          ),
          title: const Text(
            'Transaction History',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            children: [
              // Sale Tab
              _buildTransactionList(appState, 'sale'),
              // Outcome Tab
              _buildTransactionList(appState, 'outcome'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(AppState appState, String type) {
    final filteredTransactions = appState.transactions
        .where((t) => t.type == type)
        .toList();

    if (filteredTransactions.isEmpty) {
      return const Center(child: Text("No transactions yet"));
    }

    return ListView.builder(
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final t = filteredTransactions[index];
        final product = t.productId != null
            ? appState.products.firstWhere(
                (p) => p.id == t.productId,
                orElse: () =>
                    Product(id: 0, name: 'Unknown', price: 0, stock: 0),
              )
            : null;
        final date = DateTime.parse(t.date);
        final formattedDate =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: t.type == 'sale'
                  ? Colors.green.shade300
                  : Colors.red.shade300,
              child: Icon(
                t.type == 'sale' ? Icons.shopping_cart : Icons.payment,
                color: Colors.white,
              ),
            ),
            title: Text(
              t.type == 'sale'
                  ? "Sale: ${product?.name ?? 'Unknown'} x${t.quantity}"
                  : "Outcome",
            ),
            subtitle: Text(formattedDate),
            trailing: Text("\ ${formatRupiah(t.amount)}"),
          ),
        );
      },
    );
  }
}
