import 'dart:convert';

import 'package:ShopApp/providers/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//import 'package:flutter/gestures.dart';
import './cart.dart';

class OrdersItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrdersItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrdersItem> _orders = [];

  List<OrdersItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shopapp-1621f.firebaseio.com/orders.json';
    final currentTime = DateTime.now();
    final  response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts,
          'dateTime': currentTime.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrdersItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: currentTime,
      ),
    );
    notifyListeners();
  }
}
