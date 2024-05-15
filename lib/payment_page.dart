// import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_food_project2/home.dart';
import 'package:flutter_food_project2/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_food_project2/uidesign.dart';

// Define a class to represent each payment method
class PaymentMethod {
  final String title;
  final String subtitle;
  final IconData iconData;
  bool isSelected;

  PaymentMethod({
    required this.title,
    required this.subtitle,
    required this.iconData,
    this.isSelected = false,
  });
}

class PaymentPage extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> orderList;
  const PaymentPage({Key? key, required this.total, required this.orderList})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      title: 'Debit Card',
      subtitle: '1234 **** **** ****',
      iconData: Icons.credit_card,
    ),
    PaymentMethod(
      title: 'Bkash',
      subtitle: '1234****',
      iconData: Icons.credit_card,
    ),
    PaymentMethod(
      title: 'Nagad',
      subtitle: '1234******',
      iconData: Icons.credit_card,
    ),
    PaymentMethod(
      title: 'Cash on Delivery',
      subtitle: 'your address',
      iconData: Icons.credit_card,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: paymentMethods.length,
              itemBuilder: (BuildContext context, int index) {
                return buildCheckboxListTile(paymentMethods[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total Payment: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('${widget.total} tk')
              ],
            ),
          ),
          const Divider(
            indent: 25,
            endIndent: 25,
          ),
          GestureDetector(
            onTap: _showPaymentConfirmationDialog,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      'Make Payment',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCheckboxListTile(PaymentMethod paymentMethod) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: paymentMethod.isSelected ? Colors.amber : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CheckboxListTile(
          checkboxShape: const CircleBorder(),
          title: Text(
            paymentMethod.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(paymentMethod.subtitle),
          secondary: Icon(
            paymentMethod.iconData,
            color: Colors.amber,
          ),
          checkColor: Colors.white,
          activeColor: Colors.amber,
          value: paymentMethod.isSelected,
          onChanged: (value) {
            setState(() {
              // Unselect all other payment methods
              for (var method in paymentMethods) {
                method.isSelected = false;
              }
              // Select the current payment method
              paymentMethod.isSelected = value ?? false;
            });
          },
        ),
      ),
    );
  }

  void _showPaymentConfirmationDialog() {
    // Check if any payment method is selected
    bool isAnyMethodSelected =
        paymentMethods.any((method) => method.isSelected);

    if (!isAnyMethodSelected) {
      // Show a toast message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please select a payment method.'),
        ),
      );
      return;
    }

    // Show the payment confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Confirmation'),
          content: const Text('Your payment has been confirmed.'),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final jsonString = jsonEncode(widget.orderList);
                await prefs.setString('order_list', jsonString);
                log(jsonString);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Home()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
