import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Global App state with ChangeNotifier
class AppState extends ChangeNotifier {
  bool _loggedIn = false;
  String? _username;
  // Products and transactions in-memory lists
  List<Product> products = [];
  List<Transaction> transactions = [];
  Database? _db;

  bool get loggedIn => _loggedIn;
  String? get username => _username;

  // Initialize DB, load data, attempt login session restore
  Future<void> init() async {
    await _initDb();
    await _loadDataFromDb();
    await _restoreSession();
  }

  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cashier_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price REAL NOT NULL,
          stock INTEGER NOT NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER,
          type TEXT NOT NULL,
          quantity INTEGER,
          amount REAL NOT NULL,
          date TEXT NOT NULL
        )
      ''');
      },
    );
  }

  Future<void> _loadDataFromDb() async {
    if (_db == null) return;
    final prodMaps = await _db!.query('products');
    products = prodMaps.map((e) => Product.fromMap(e)).toList();
    final transMaps = await _db!.query('transactions', orderBy: 'date DESC');
    transactions = transMaps.map((e) => Transaction.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('username');
    if (user != null) {
      _loggedIn = true;
      _username = user;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _loggedIn = true;
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }

  Future<void> logout() async {
    _loggedIn = false;
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }

  Future<void> changeUsername(String newUsername) async {
    _username = newUsername;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (_db == null) return;
    final id = await _db!.insert('products', product.toMap());
    product.id = id;
    products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (_db == null) return;
    await _db!.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
    int idx = products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      products[idx] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(int id) async {
    if (_db == null) return;
    await _db!.delete('products', where: 'id = ?', whereArgs: [id]);
    products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    if (_db == null) return;
    final id = await _db!.insert('transactions', transaction.toMap());
    transaction.id = id;
    transactions.insert(0, transaction);
    notifyListeners();
  }

  Future<void> syncData() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint("Data synced with server (simulated).");
  }
}

class Product {
  int? id;
  String name;
  double price;
  int stock;
  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'stock': stock,
  };
  static Product fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    price: map['price'],
    stock: map['stock'],
  );
}

class Transaction {
  int? id;
  int? productId;
  String type;
  int? quantity;
  double amount;
  String date;
  Transaction({
    this.id,
    this.productId,
    required this.type,
    this.quantity,
    required this.amount,
    required this.date,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'type': type,
    'quantity': quantity,
    'amount': amount,
    'date': date,
  };
  static Transaction fromMap(Map<String, dynamic> map) => Transaction(
    id: map['id'],
    productId: map['productId'],
    type: map['type'],
    quantity: map['quantity'],
    amount: map['amount'],
    date: map['date'],
  );
}
