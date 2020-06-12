import 'package:flutter/material.dart';
import '../widgets/ProductGrid.dart';
class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product overview'),
      ),
      body: ProductGrid(),
    );
  }
}

