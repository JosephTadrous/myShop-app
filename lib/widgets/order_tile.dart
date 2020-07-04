import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderTile extends StatefulWidget {
  final OrderItem order;

  OrderTile(this.order);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  var _extended = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text(
              '\$${widget.order.amount}',
            ),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_extended ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _extended = !_extended;
                });
              },
            ),
          ),
        ),
        if (_extended)
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.order.products.length * 20.0 + 10.0, 100.0),
            child: ListView(
              children: widget.order.products
                  .map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${prod.quantity}x \$${prod.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
