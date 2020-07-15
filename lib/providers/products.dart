import 'package:MyShop/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// to convert data to another type
import 'dart:convert';

import '../providers/product.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;

  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);

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
    final url =
        'https://flutter-myshop-8e098.firebaseio.com/products.json?auth=$authToken';
    // need to add data as a JSON type (same syntax as a map)
    try {
      // await indicates that what comes after it is executed after the await function is done
      final response = await http.post(
        url,
        body: json.encode({
          'creatorId' : userId,
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
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

  Future<void> fetchAndSetProducts([bool filterProducts = false]) async {
    // filter the data in the server by the creator Id
    final filterSegment = filterProducts ?  '&orderBy="creatorId"&equalTo="$userId"' : '';    
    var url =
        'https://flutter-myshop-8e098.firebaseio.com/products.json?auth=$authToken$filterSegment';
    try {
      final response = await http.get(url);
      List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          'https://flutter-myshop-8e098.firebaseio.com/userProducts/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://flutter-myshop-8e098.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Optimistic Updating Approach
  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-myshop-8e098.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductInd = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductInd]; // pointer to the product
    _items.removeAt(
        existingProductInd); // product is deleted from the list but still exists in memory cuz we have a pointer to it
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductInd, existingProduct); // insert it back
      notifyListeners();
      throw HttpException('Couldn\'t delete product.'); // custom exception
    }
    existingProduct =
        null; // pointer is removed, and thus product is deleted from memory
  }
}
