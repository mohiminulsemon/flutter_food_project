// import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_food_project2/model/customer_list.dart';
// import 'package:flutter_food_project2/model/order_list.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_food_project2/model/customer_list.dart';
import 'package:flutter_food_project2/payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCarts extends StatefulWidget {
  final Map<String, dynamic>? cartItem;

  const MyCarts({this.cartItem, super.key});

  @override
  State<MyCarts> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyCarts> {
  // List<Map<String, dynamic>> orderList = order_list();
  List<Map<String, dynamic>> customer_list = customerList();
  List<Map<String, dynamic>> orderList = [];

  void _fetchCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemIds = prefs.getStringList('cart_items');
    if (cartItemIds != null && cartItemIds.isNotEmpty) {
      setState(() {
        // Create a Map to store the count of each item ID
        Map<String, int> itemCountMap = {};

        // Count occurrences of each item ID in cartItemIds
        for (var id in cartItemIds) {
          itemCountMap[id] = (itemCountMap[id] ?? 0) + 1;
        }

        // Filter customerList() based on cartItemIds and update the count
        orderList = customerList()
            .where((item) => cartItemIds.contains(item['id'].toString()))
            .toList();

        // Update the count in orderList based on itemCountMap
        for (var item in orderList) {
          item['count'] = itemCountMap[item['id'].toString()] ?? 0;
        }
      });
      log(orderList.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 60;
    double discount = 30;
    double totalAmount = 0;
    double orderAmount = 0;
    for (int i = 0; i < orderList.length; i++) {
      orderAmount += orderList[i]['count'] * orderList[i]['price'];
    }
    totalAmount = orderAmount - discount + deliveryFee;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Carts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: orderList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order List',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: orderList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        // onPressed: () {
                                        //   setState(() {
                                        //     orderList.removeAt(index);
                                        //   });
                                        // },
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          List<String>? cartItemIds =
                                              prefs.getStringList('cart_items');
                                          if (cartItemIds != null) {
                                            // Remove all occurrences of the item ID from SharedPreferences
                                            cartItemIds.removeWhere((id) =>
                                                id ==
                                                orderList[index]['id']
                                                    .toString());
                                            await prefs.setStringList(
                                                'cart_items', cartItemIds);
                                          }

                                          // Remove all occurrences of the item from orderList
                                          setState(() {
                                            orderList.removeWhere((item) =>
                                                item['id'] ==
                                                orderList[index]['id']);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    Image.network(
                                      orderList[index]['image'],
                                      width: 60,
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                                title: Text(
                                  orderList[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(orderList[index]['price'].toString()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (orderList[index]['count'] > 1) {
                                              orderList[index]['count']--;
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.remove)),
                                    // Text(orderList[index]['count'].toString()),
                                    SizedBox(
                                      width: 40,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: TextEditingController(
                                            text: orderList[index]['count']
                                                .toString()),
                                        onChanged: (value) {
                                          int parsedValue =
                                              int.tryParse(value) ?? 1;
                                          if (parsedValue >= 1) {
                                            setState(() {
                                              orderList[index]['count'] =
                                                  parsedValue;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            orderList[index]['count']++;
                                          });
                                        },
                                        icon: const Icon(Icons.add)),
                                  ],
                                ),
                              );
                            })),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Amount',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(orderAmount.toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Delivery Fee',
                                      style: TextStyle(color: Colors.grey)),
                                  Text(deliveryFee.toStringAsFixed(2))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('- ${discount.toStringAsFixed(2)}')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text('TK= ${totalAmount.toStringAsFixed(2)}\$'),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentPage(
                                            total: totalAmount,
                                            orderList: orderList,
                                          )));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.amber),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  child: Text(
                                    'Payment',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const Center(child: Text("No Order Found")));
  }
}
