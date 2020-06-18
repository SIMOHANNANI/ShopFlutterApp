import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
//    final _orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).dataBaseOperation(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(
                child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: CircularProgressIndicator()));
          } else {
            // We're done for the async computation
            if (data.error == null) {
              return Consumer<Orders>(
                builder: (ctx, _orders,child)=>ListView.builder(
                  itemCount: _orders.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(_orders.orders[i]),
                )

              );
            }
          }
          return Center(child:Text('No data found on the server !'));
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
