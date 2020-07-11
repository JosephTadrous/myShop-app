import 'package:MyShop/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../widgets/order_tile.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      // using FutureBuilder to improve the code/ handling futures/ loading/ errors 
      body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchAndSetOrder(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapShot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, ordersData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderTile(ordersData.orders[i]),
                    itemCount: ordersData.orders.length),
              );
            }
          }),
    );
  }
}
