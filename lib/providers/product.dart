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

  // Optimistic Update Approach: storing the old value and restoring it if an error occurred
  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = this.isFavorite;
    try {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
      final url =
          'https://flutter-myshop-8e098.firebaseio.com/userProducts/$userId/${this.id}.json?auth=$token';
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
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
