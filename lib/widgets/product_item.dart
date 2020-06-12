import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: id);
          // forward the id of the product the the product detail screen ,That's allow us to obtain the
          // the other property of the product ...
        },
          child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      )),
      footer: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        child: GridTileBar(
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black38,
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            )),
      ),
    );
  }
}
