import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_products_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshIndicator(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .dataBaseOperation(true);
  }

  @override
  Widget build(BuildContext context) {
//    final products = Provider.of<ProductsProvider>(context);
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
      body: FutureBuilder(

        future: _refreshIndicator(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: CircularProgressIndicator()),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshIndicator(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, products, _) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        child: ListView.builder(
                          itemCount: products.products.length,
                          itemBuilder: (_, i) => UserProductItem(
                            id: products.products[i].id,
                            title: products.products[i].title,
                            imageUrl: products.products[i].imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
