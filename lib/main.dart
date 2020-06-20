// Packages ...
import 'package:ShopApp/providers/orders.dart';
import 'package:ShopApp/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

//import './screens/product_overview_screen.dart';
// Providers ...
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

// Screens ...
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_waiting_screen.dart';

void main() {
  runApp(MyApp());
  // TO hide the status bar
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (_) => ProductsProvider(null, null, []),
            update: (_, auth, previous) => ProductsProvider(
                auth.token,
                auth.userId,
                previous.products == null ? [] : previous.products),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, null, []),
            update: (_, auth, previous) => Orders(auth.token, auth.userId,
                previous.orders == null ? [] : previous.orders),
          ),
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

        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shopping in efficient way',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              accentColor: Colors.yellow,
              fontFamily: 'Lato',
            ),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoSignIn(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
