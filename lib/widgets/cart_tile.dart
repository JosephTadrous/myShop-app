import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartTile extends StatelessWidget {
  final String id;
  final String title;
  final String productId;
  final double price;
  final int quantity;

  CartTile(this.id, this.productId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
      
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${price * quantity}'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
