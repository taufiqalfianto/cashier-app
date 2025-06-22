import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pos/common/style/color.dart';
import 'package:pos/database/database.dart';
import 'package:pos/feature/product/add_new_product_screen.dart';
import 'package:pos/feature/product/product_screen.dart';
import 'package:pos/feature/profile/profile_screen.dart';
import 'package:pos/feature/transaction/transaction_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum HomeTab { products, sales, profile }

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _currentTab = HomeTab.products;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  String _connectionStatus = "Unknown";

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      setState(() {
        _connectionStatus = result.toString().split('.').last;
      });
      // if(result != ConnectivityResult.none){
      //   Provider.of<AppState>(context, listen: false).syncData();
      // }
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentTab) {
      case HomeTab.products:
        body = const ProductListScreen();
        break;
      case HomeTab.sales:
        body = const TransactionScreen();
        break;
      case HomeTab.profile:
        body = const ProfileScreen();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Cashier App - ${_currentTab.name.toUpperCase()}"),
        elevation: 10,
        shadowColor: AppColors.shadow,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Tambah Produk",
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNewProductScreen()),
        ),
      ),
      body: Column(children: [Expanded(child: body)]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: HomeTab.values.indexOf(_currentTab),
        onDestinationSelected: (i) => setState(() {
          _currentTab = HomeTab.values[i];
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Products",
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Transactions",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile", 
          ),
        ],
      ),
    );
  }
}
