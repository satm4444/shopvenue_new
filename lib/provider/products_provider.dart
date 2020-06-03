import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopvenue/exception/http_exception.dart';

import 'package:shopvenue/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String _userId;

  List<Product> _items = [
    // Product(
    //     id: "1",
    //     title: "Watch",
    //     price: 200,
    //     description: "The best watch that fits both classy and modern look",
    //     imageURL:
    //         "https://images-na.ssl-images-amazon.com/images/I/71vKyimxsiL._UX569_.jpg",
    //     isFavourite: false),
  ];

  Products(
    this.authToken,
    this._userId,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favourites {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://shop-venue-a08e1.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'createrId': _userId,
          },
        ),
      );

      print(
        json.decode(response.body)['name'],
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageURL: product.imageURL,
        title: product.title,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }

    // .catchError((error) {

    // }
    // );
  }

//for fetching products from firebase

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="createrId"&equalTo="$_userId"' : "";

    final url =
        "https://shop-venue-a08e1.firebaseio.com/products.json?auth=$authToken&$filterString";

    try {
      final response = await http.get(url);
      final extracedData = json.decode(response.body) as Map<String, dynamic>;
      final favouriteResponse = await http.get(
          "https://shop-venue-a08e1.firebaseio.com/userFavourites/$_userId.json?auth=$authToken");
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedproducts = [];
      extracedData.forEach((prodId, prodData) {
        loadedproducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: double.parse(prodData['price'].toString()),
              isFavourite: favouriteData == null
                  ? false
                  : favouriteData[prodId] ?? false,
              imageURL: prodData['imageURL']),
        );
      });
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product upProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url =
            "https://shop-venue-a08e1.firebaseio.com/products/$id.json?auth=$authToken";
        await http.patch(url,
            body: json.encode({
              'title': upProduct.title,
              'price': upProduct.price,
              'description': upProduct.description,
              'imageURL': upProduct.imageURL,
              'isFavourite': upProduct.isFavourite,
            }));

        _items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (error) {}
  }

  // void deleteProduct(String id) {
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-venue-a08e1.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex =
        items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException("Couldn't delete");
      } else {
        existingProduct = null;
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Couldn't delete");
    }
  }
}
