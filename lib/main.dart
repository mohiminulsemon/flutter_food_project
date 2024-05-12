import 'package:flutter/material.dart';
import 'package:flutter_food_project2/home.dart';
import 'package:flutter_food_project2/tab_bar.dart';
// import 'package:flutter_food_project2/payment_page.dart';
// import 'package:flutter_food_project2/uidesign.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:  FoodDetails()
      // home: Uidesign(),
      home: Home(),
      // home: TabBarPreview(),
      // home: PaymentPage()
    );
  }
}
