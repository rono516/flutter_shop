import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routName = 'orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Hello Friend'),
      ),
      // body: ListView.builder(
      //   itemBuilder: (ctx, i)=> ,
      //   itemCount: orderData.orders.length,
      // ),
    );
  }
}
