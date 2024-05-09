// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_food_project2/model/customer_list.dart';
import 'package:flutter_food_project2/model/order_list.dart';
import 'package:flutter_food_project2/payment_page.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, dynamic>> orderList = order_list();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total amount
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
            'My Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order List',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                onPressed: () {
                                  setState(() {
                                    orderList.removeAt(index);
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(orderList[index]['price'].toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (orderList[index]['count'] > 1)
                                      orderList[index]['count']--;
                                  });
                                },
                                icon: const Icon(Icons.remove)),
                            // Text(orderList[index]['count'].toString()),
                            Container(
                              width: 40,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: orderList[index]['count'].toString()),
                                onChanged: (value) {
                                  int parsedValue = int.tryParse(value) ?? 1;
                                  if (parsedValue >= 1) {
                                    setState(() {
                                      orderList[index]['count'] = parsedValue;
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
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Amount',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(orderAmount.toStringAsFixed(2))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee',
                                style: TextStyle(color: Colors.grey)),
                            Text(deliveryFee.toStringAsFixed(2))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                builder: (context) =>
                                    PaymentPage(total: totalAmount)));
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
        ));
  }
}
