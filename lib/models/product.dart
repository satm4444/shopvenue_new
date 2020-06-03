//---------Product details-------------
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageURL;
  bool isFavourite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.imageURL,
      this.isFavourite = false});
  Future<void> toggleIsFavourite(String authToken, String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        "https://shop-venue-a08e1.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken";

    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
        notifyListeners();
      }
    } catch (error) {}
  }
}
