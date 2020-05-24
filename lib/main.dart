import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/cart_provider.dart';
import 'package:shopvenue/provider/order_provider.dart';
import 'package:shopvenue/provider/products_provider.dart';
import 'package:shopvenue/screen/cart_screen.dart';
import 'package:shopvenue/screen/edit_product_screen.dart';
import 'package:shopvenue/screen/order_screen.dart';
import 'package:shopvenue/screen/product_detail_screen.dart';
import 'package:shopvenue/screen/product_overview_screen.dart';
import 'package:shopvenue/screen/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shopvenue",
        theme: ThemeData(
          primaryColor: Color(0xff852136),
          accentColor: Color(0xff8f242e),
          fontFamily: "Nunito",
        ),
        initialRoute: "/",
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
