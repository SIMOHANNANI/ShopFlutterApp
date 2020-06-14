import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    // take the id forwarded when pushing named page .
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final targetedID = products.findById(productID);

    return Scaffold(
      appBar: AppBar(
        title: Text(targetedID.title),
      ),
      body: Container(
        child: Card(),
      ),
    );
  }
}
