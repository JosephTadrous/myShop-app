import 'package:MyShop/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../widgets/order_tile.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: ListView.builder(
            itemBuilder: (ctx, i) => OrderTile(ordersData.orders[i]),
            itemCount: ordersData.orders.length));
  }
}
