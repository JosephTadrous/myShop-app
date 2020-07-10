import 'dart:convert';
import 'package:MyShop/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      @required this.title,
      this.isFavorite = false});

  // Optimistic Update Approach
  Future<void> toggleFavorite() async {
    final url =
        'https://flutter-myshop-8e098.firebaseio.com/products/${this.id}.json';
    final oldStatus = this.isFavorite;
    try {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': this.isFavorite}),
      );
      if (response.statusCode >= 400) {
        this.isFavorite = oldStatus;
        notifyListeners();
        throw HttpException("Couldn't change favorite status.");
      }
    } catch (error) {
      throw error;
    }
  }
}
