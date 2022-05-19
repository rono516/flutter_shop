import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
// import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  // const OrderItem({Key? key}) : super(key: key);
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Ksh.${order.amount}'),
            subtitle: Text('hello here'),
          )
        ],
      ),
    );
  }
}
