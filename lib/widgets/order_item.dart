import 'package:flutter/material.dart';
import '../providers/orders.dart' as orders;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final orders.OrdersItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 10.0,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat('dd MM yyyy | hh:mm').toString()),
            trailing: IconButton(
              icon: Icon(Icons.description),
              onPressed: (){

              },
            ),
          ),
        ],
      ),
    );
  }
}
