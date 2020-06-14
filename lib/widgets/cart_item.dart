import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('confirming the deletion'),
            content: Text(
              'Are you use you want to delete that item from the cart',
            ),
            actions: <Widget>[
              FlatButton(child: Text('No'),onPressed: (){
                Navigator.of(ctx).pop(false);
              },),
              FlatButton(child: Text('Yes'),onPressed: (){
                Navigator.of(ctx).pop(true);
              },)
            ],
          ),
        );
      },
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeCart(productId),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(child: Text('\$$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('\$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
