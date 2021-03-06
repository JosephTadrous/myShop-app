import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        // wait for the future and then build
        future: refreshProducts(context),
        builder: (context, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<Products>(
                        builder: (ctx, productData, _) => ListView.builder(
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: [
                                  UserProductItem(
                                      productData.items[i].id,
                                      productData.items[i].title,
                                      productData.items[i].imageUrl),
                                  Divider(),
                                ],
                              );
                            },
                            itemCount: productData.items.length),
                      ),
                    ),
                  ),
      ),
    );
  }
}
