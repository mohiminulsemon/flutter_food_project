import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, dynamic>> orderList = [];

  _fetchOrderList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('order_list');
    // log('orders page : ${jsonString.toString()}');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      log('orders page : ${jsonList.toString()}');
      setState(() {
        orderList =
            jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
      // log(orderList.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount:
            orderList.length, // Using orderList instead of widget.orderList
        itemBuilder: (context, index) {
          // Using orderList instead of widget.orderList
          return ListTile(
            title: Text(
                orderList[index]['name']), // Accessing 'name' from orderList
            subtitle: Text(orderList[index]['price']
                .toString()), // Accessing 'price' from orderList
          );
        },
      ),
    );
  }
}
