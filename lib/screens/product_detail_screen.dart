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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 400.0,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Card(
              child: Image.network(
                targetedID.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '\$${targetedID.price}',
            style: TextStyle(fontSize: 40.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
            child: Text(
              targetedID.description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ]),
      ),
    );
  }
}
