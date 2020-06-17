import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;

  final String description;
  final double price;

  final String imageUrl;
  bool isFavorite;

  // Add constructor :
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false
  });

  Future<void> toggleProductFavorite() async {
    final url = 'https://shopapp-1621f.firebaseio.com/products/$id.json';
    final favoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.patch(url, body: jsonEncode({
        'isFavorite': isFavorite
      }));
    }catch(error){
      isFavorite = favoriteStatus;
    }
  }
}