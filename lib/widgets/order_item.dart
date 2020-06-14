import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/orders.dart' as orders;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final orders.OrdersItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

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
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy | hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            height: min(widget.order.products.length * 20.0 + 30, 180.0),
            child:ListView(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              children: widget.order.products.map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(e.title,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                  Text('${e.quantity}x \$${e.price}'),

                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
