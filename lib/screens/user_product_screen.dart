import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../providers/products_provider.dart';
import '../widgets/user_products_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget with ChangeNotifier {
  static const routeName = '/user-product';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //... Navigation to the new product screen
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
        child: ListView.builder(
          itemCount: products.products.length,
          itemBuilder: (_, i) => UserProductItem(
            title: products.products[i].title,
            imageUrl: products.products[i].imageUrl,
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}