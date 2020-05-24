import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/products_provider.dart';
import 'package:shopvenue/screen/edit_product_screen.dart';
import 'package:shopvenue/widgets/app_drawer.dart';
import 'package:shopvenue/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user_product_screen";

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (ctx, index) => UserProductItem(
              products[index].id,
              products[index].title,
              products[index].imageURL,
            ),
            itemCount: products.length,
          ),
        ),
      ),
    );
  }
}
