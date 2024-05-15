import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_food_project2/favourites.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/widgets.dart';


class FoodDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final String name;
  // final List<Map<String, dynamic>> cart;
  const FoodDetails({super.key, required this.data, required this.name});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  bool isFavorite = false;

  // Method to add the item ID to SharedPreferences
  void _addToCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart_items') ?? [];
    cartItems.add(widget.data['id'].toString());
    await prefs.setStringList('cart_items', cartItems);
    // log(cartItems.toString());
  }

  Widget commonImages() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.data['image'],
            height: 150,
            width: 150,
            fit: BoxFit.fill,
          )),
    );
  }

  void checkFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favItems = prefs.getStringList('favItems');
    if (favItems != null) {
      setState(() {
        isFavorite = favItems.contains(widget.data['id'].toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

// Method to toggle favorite status
  void toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favItems = prefs.getStringList('favItems') ?? [];
    if (isFavorite) {
      favItems.remove(widget.data['id'].toString());
    } else {
      favItems.add(widget.data['id'].toString());
    }
    await prefs.setStringList('favItems', favItems);
    setState(() {
      isFavorite = !isFavorite;
    });

    log(favItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyFavourites()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.data['image'],
                    height: 300,
                    width: MediaQuery.of(context).size.width * 1,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.data['name'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lock_clock,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    '${widget.data['time']} min',
                                    style: const TextStyle(color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.red,
                                ),
                                Text(
                                  widget.data['rating'].toString(),
                                  style: const TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.data['price']}\$',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        'Navigation and routing are some of the core concepts of all mobile application, which allows the user to move between different pages. We know that every mobile application contains several screens for displaying different types of information. For example, an app can have a screen that contains various products.'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Recently Viewed',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return commonImages();
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  toggleFavorite();
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  _addToCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Successfully added to cart.'),
                    ),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
