import 'package:ShopApp/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx)=> ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx)=>Orders())
      ],

      // but if we using an existing instantiation if a class we can use
      // the other approach ...

      // If we're not using the context ,we can simply do :
      // return ChangeNotifierProvider.value(value: ProductsProvider())
      // We have to use that approach when we have the provider package
      // and we're providing our data on single list or grid items when flutter
      // then flutter then actually will recyle the widget we're attaching our
      // provider to ...

      // As we need more than one provider ,the provider package has been manged
      // that to use MultiProvider class .

      child: MaterialApp(
        title: 'Shopping in efficient way',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.yellow,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName:(context)=> CartScreen(),
        },
      ),
    );
  }
}
