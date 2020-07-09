import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// to convert data to another type
import 'dart:convert';

import '../providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // get a copy of items
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // we converted addProduct to a future so we can render a loading spinner on the screen while the data is being posted to the data base
  // the async and await keywords result in asynchronous code that looks a lot like synchronous code.
  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-myshop-8e098.firebaseio.com/products.json';
    // need to add data as a JSON type (same syntax as a map)
    try {
      // await indicates that what comes after it is executed after the await function is done
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite
        }),
      );
      final newProduct = Product(
          // firebase database understands json language so we need to encode/decode between dart and json when dealing with data on the server
          id: json.decode(
              response.body)['name'], // unique id provided by the backend,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description);
      _items.add(newProduct);
      //  _items.insert(0, newProduct)  to add at the beginning of the list
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-myshop-8e098.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
