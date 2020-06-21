import 'package:ShopApp/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // When we wanna just a subpart of the builder to be interested by the
    // changes we've to use the consumer widget;
    final auth = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (ctx, product, child) => GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
              // forward the id of the product the the product detail screen ,That's allow us to obtain the
              // the other property of the product ...
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/img/placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
          child: GridTileBar(
              leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleProductFavorite(auth.token, auth.userId);
                },
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: Colors.black38,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Adding item to card ...',
                      style: TextStyle(
                        wordSpacing: 10,
                        letterSpacing: 5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleCart(product.id);
                      },
                    ),
                  ));
                },
                color: Theme.of(context).accentColor,
              )),
        ),
      ),
    );
  }
}
