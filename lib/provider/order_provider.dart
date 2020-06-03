import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopvenue/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<OrderItem> _orders = [];

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

//adding cart
  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final url =
        "https://shop-venue-a08e1.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "dateTime": DateTime.now().toIso8601String(),
            "products": cartproducts
                .map((e) => {
                      "id": e.id,
                      "quantity": e.quantity,
                      "price": e.price,
                      "title": e.title
                    })
                .toList()
          },
        ),
      );
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: total,
              products: cartproducts,
              dateTime: DateTime.now()));
    } catch (error) {}
  }

//====adding cart items to order list=========
  // void addOrder(List<CartItem> cartProducts, double total) {
  //   _orders.insert(
  //       0,
  //       OrderItem(
  //           id: DateTime.now().toString(),
  //           amount: total,
  //           products: cartProducts,
  //           dateTime: DateTime.now()));
  //   notifyListeners();
  // }

  //for fetching orders from database

  Future<void> fetandSetorders() async {
    final url =
        "https://shop-venue-a08e1.firebaseio.com/orders/$_userId.json?auth=$_authToken";

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> _loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item["id"],
                      price: double.parse(item["price"].toString()),
                      quantity: item['quantity'],
                      title: item['itle'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
