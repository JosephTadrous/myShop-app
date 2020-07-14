import 'package:MyShop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor),
              onPressed: () async {
                try {
                  await product.toggleFavorite(auth.token);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Couldn't change the favorite status"),
                    ),
                  );
                }
              }),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: Theme.of(context).accentColor),
              onPressed: () {
                cart.addItems(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added to the cart',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
