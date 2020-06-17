import 'package:ShopApp/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ProductGrid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum FilterLabel {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _initStart = true;
  bool _isLoading = false;

//  @override
//  void initState() {
//    Future.delayed(Duration.zero).then((value){
//    Provider.of<ProductsProvider>(context,listen: false).dataBaseOperation();
//    });
//    super.initState();
//  }
  // To fetch the data from the firebase frm here we can also :
  @override
  void didChangeDependencies() async {
    if (_initStart) {
      _isLoading = true;
      Provider.of<ProductsProvider>(context).dataBaseOperation().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initStart = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    final products = Provider.of<ProductsProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products overview'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterLabel selectedValue) {
              setState(() {
                if (selectedValue == FilterLabel.Favorites) {
                  // ... Show only favorites products .
//                products.showFavoriteOnly();
                  _showFavoriteOnly = true;
                } else {
                  // ... Show all available products .
//                products.showAll();
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show only favorite products'),
                value: FilterLabel.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all products'),
                value: FilterLabel.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading?Center(child: CircularProgressIndicator(),):ProductGrid(_showFavoriteOnly),
    );
  }
}
