import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/models/product.dart';
import 'package:shopvenue/provider/cart_provider.dart';
import 'package:shopvenue/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0)),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: 'product${selectedProduct.id}',
            child: Image.network(
              selectedProduct.imageURL,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: selectedProduct.id);
          },
        ),
        footer: GridTileBar(
          //backgroundColor: Colors.orange.withOpacity(0.7),
          backgroundColor: Colors.black.withOpacity(0.7),
          title: Text(
            selectedProduct.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, prod, _) {
              return IconButton(
                icon: Icon(
                    prod.isFavourite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  prod.toggleIsFavourite();
                },
                color: Theme.of(context).accentColor,
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(selectedProduct.id, selectedProduct.price,
                  selectedProduct.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Added Item to the Cart"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeSingleItem(selectedProduct.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
