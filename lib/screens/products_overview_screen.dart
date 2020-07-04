import 'package:MyShop/widgets/app_drawer.dart';
import 'package:MyShop/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';

enum FilterProducts { Favorites, All }

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterProducts value) {
                setState(() {
                  if (value == FilterProducts.Favorites) {
                    showFavorites = true;
                  } else {
                    showFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text('Favorites'),
                      value: FilterProducts.Favorites,
                    ),
                    PopupMenuItem(
                        child: Text('All Products'), value: FilterProducts.All),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      body: ProductsGrid(showFavorites),
    );
  }
}
