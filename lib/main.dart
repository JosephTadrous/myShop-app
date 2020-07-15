import 'package:MyShop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        // passing data between two providers
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts.items == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order(null, null, []),
          update: (ctx, auth, previousOrders) => Order(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ], //instance of the products
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.purple,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsScreen()
              : FutureBuilder(
                  // rebuilds Consumer<Auth> since we notifiedListiners when calling tryAutoLogin,
                  future: auth.tryAutoLogin(),                  
                  builder: (ctx, userAuthSnapShot) =>
                      userAuthSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
