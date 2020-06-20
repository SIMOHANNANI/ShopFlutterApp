import 'package:flutter/material.dart';

//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
  ];
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._products);

  List<Product> get products {
    //    if (!_showFavoritesOnly) {
    //      return [..._products]; // Return a copy of the product list
    //    }
    //    return _products.where((element) => element.isFavorite).toList();
    return [..._products]; // Return a copy of the product list
  }

  Future<void> dataBaseOperation([bool filterByUser = false]) async {
    String filerMess = filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    // Fetching the product present in the database:
    var url =
        'https://shopapp-1621f.firebaseio.com/products.json?auth=$authToken&$filerMess';
    // final for runtime constant
    // const from compile time constant
    try {
      final response = await http.get(url);
      final gatheredData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loaderProducts = [];
      url =
          'https://shopapp-1621f.firebaseio.com/favoriteProducts/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(url);
      final favoriteProduct = jsonDecode(favoriteResponse.body);
      if (gatheredData != null) {
        gatheredData.forEach((key, value) {
          // loop through the map of products ,
          // the key is the product id
          // and actually the value is the product data .
          loaderProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite:
                favoriteProduct == null ? false : favoriteProduct[key] ?? false,
          ));
        });
      }
      _products = loaderProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-1621f.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
//          'isFavorite': product.isFavorite,
          'userId': userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _products.add(newProduct);
      // Add at the beginning of the list
      //    _products.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final _productUpdateIndex =
        _products.indexWhere((element) => element.id == id);
    if (_productUpdateIndex >= 0) {
      final url =
          'https://shopapp-1621f.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
      } catch (error) {
        throw error;
      }

      // sending a post request :

      _products[_productUpdateIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) async {
    final indexWillDeleteProduct =
        _products.indexWhere((element) => id == element.id);
    var willDeleteProduct = _products[indexWillDeleteProduct];
    _products.removeAt(indexWillDeleteProduct);
    final url =
        'https://shopapp-1621f.firebaseio.com/products/$id.json?auth=$authToken';
    await http.delete(url).then((_) {
      willDeleteProduct = null;
    }).catchError((_) {
      _products.insert(indexWillDeleteProduct, willDeleteProduct);
    });
    _products.removeWhere((element) => element.id == id);

    notifyListeners();
  }
}
