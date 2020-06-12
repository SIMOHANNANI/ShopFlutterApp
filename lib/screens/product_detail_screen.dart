import 'package:flutter/material.dart';
class ProductDetailScreen extends StatelessWidget{
  static const routeName = 'product-detail';
  @override
  Widget build(BuildContext context){

    final productID = ModalRoute.of(context).settings.arguments as String;
    // take the id forwarded when pushing named page .
    return Scaffold(
      appBar:AppBar(
        title: Text(productID),

      ),
      body: Container(
        child: Card(),
      ),
    );
  }
}