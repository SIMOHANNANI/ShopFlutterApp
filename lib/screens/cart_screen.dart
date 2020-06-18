import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/card';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$' + cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  PurchaseButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseButton extends StatefulWidget {
  const PurchaseButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _PurchaseButtonState createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
              strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepOrange,
                ),
              ),
            )
          : Text('Purchase now'),
      onPressed: (widget.cart.itemCount > 0 || _isLoading)
          ? () async {
              setState(() {
                _isLoading = true;
              });
              // Adding orders :
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            }
          : null,
      textColor: Theme.of(context).primaryColor,
    );
  }
}
