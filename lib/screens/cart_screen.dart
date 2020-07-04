import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/order.dart';
import '../widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalPrice);
                      cart.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return CartTile(
                      cart.items.values.toList()[i].id,
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].title,                      
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity);
                },
                itemCount: cart.itemCount),
          )
        ],
      ),
    );
  }
}
