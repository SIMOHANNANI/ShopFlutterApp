import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
void main()=> runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create:(ctx)=> ProductsProvider(),
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
          ProductDetailScreen.routeName:(context)=>ProductDetailScreen(),
        },

      ),
    );
  }
}