import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  String authToken;

  List<OrderItem> _orders = [];

  Order(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-myshop-8e098.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now().toIso8601String();
    final response = await http.post(
      url,
      body: json.encode({
        'price': total,
        'dateTime': timeStamp,
        // map the cartProducts to a map
        'products': cartProducts.map((cp) {
          return {
            'id': cp.id,
            'price': cp.price,
            'quantity': cp.quantity,
            'title': cp.title
          };
        }).toList()
      }),
    );
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    final url = 'https://flutter-myshop-8e098.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem>loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['price'],
            products: (orderData['products'] as List<dynamic>)
                .map((prod) => CartItem(
                    id: prod['id'],
                    price: prod['price'],
                    title: prod['title'],
                    quantity: prod['quantity']))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
