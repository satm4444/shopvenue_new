import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopvenue/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: "1",
    //     title: "Watch",
    //     price: 200,
    //     description: "The best watch that fits both classy and modern look",
    //     imageURL:
    //         "https://images-na.ssl-images-amazon.com/images/I/71vKyimxsiL._UX569_.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "2",
    //     title: "Car",
    //     price: 200000,
    //     description: "Safest and Fastest Car",
    //     imageURL:
    //         "https://c.ndtvimg.com/2019-12/124adp6o_mclaren-620r_625x300_10_December_19.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "3",
    //     title: "Shoes",
    //     price: 1000,
    //     description: "Best Sport Shoes",
    //     imageURL:
    //         "https://static.zumiez.com/skin/frontend/delorum/default/images/champion-rally-pro-shoes-feb19-444x500.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "4",
    //     title: "Laptop",
    //     price: 250000,
    //     description: "Best Laptop for Gaming and Animation",
    //     imageURL:
    //         "https://d4kkpd69xt9l7.cloudfront.net/sys-master/images/ha5/h7f/9176281251870/razer-blade-15-usp01-mobile-gaming-laptop-v1.jpg",
    //     isFavourite: false),
    // Product(
    //     id: "5",
    //     title: "TV",
    //     price: 25000,
    //     description: "4K Curved Display",
    //     imageURL:
    //         "https://www.starmac.co.ke/wp-content/uploads/2019/08/samsung-65-inch-ultra-4k-curved-tv-ua65ku7350k-series-7.jpg",
    //     isFavourite: false)
  ];

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
    const url = "https://shop-venue-a08e1.firebaseio.com/products.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'isFavourite': product.isFavourite,
          }));

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

  Future<void> fetchAndSetProducts() async {
    const url = "https://shop-venue-a08e1.firebaseio.com/products.json";

    try {
      final response = await http.get(url);
      final extracedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedproducts = [];
      extracedData.forEach((prodId, prodData) {
        loadedproducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: double.parse(prodData['price'].toString()),
              isFavourite: prodData['isFavourite'],
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

  void updateProduct(String id, Product upProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = upProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
