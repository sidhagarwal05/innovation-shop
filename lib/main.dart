import 'package:flutter/material.dart';
import 'package:innovtion/screens/base.dart';
import 'package:innovtion/screens/example.dart';
import 'package:innovtion/screens/home.dart';
import 'package:innovtion/screens/item.dart';
import 'package:innovtion/screens/loader.dart';
import 'package:innovtion/screens/page.dart';
import 'package:innovtion/screens/previousOrders.dart';
import 'package:innovtion/screens/splash_screen.dart';
import 'package:innovtion/screens/status.dart';
import 'package:innovtion/screens/user_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innovation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        UserInfoScreen.routeName: (ctx) => UserInfoScreen(false),
        ExampleScreen.routeName: (ctx) => ExampleScreen(),
        Base.routeName: (ctx) => Base(),
        Item.routeName: (ctx) => Item(),
        Status.routeName: (ctx) => Status(),
        PreviousOrders.routeName: (ctx) => PreviousOrders(),
        Screen.routeName: (ctx) => Screen(),
        Page1.routeName: (ctx) => Page1(),
      },
    );
  }
}
