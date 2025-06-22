import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16.w,
                        runSpacing: 16.h,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100.h,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (p.stock > 0) {
                                    p.stock++;
                                    await appState.updateProduct(p);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ), 
          ),
        ],
      ),
    );
  }
}
