import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_food_project2/food_details.dart';
import 'package:flutter_food_project2/model/customer_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  List<Map<String, dynamic>> customer_list = customerList();
  List<Map<String, dynamic>> myList = [];

  void fetchFavourits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favItems = prefs.getStringList('favItems') ?? [];

    if (favItems != Null && favItems.isNotEmpty) {
      setState(() {
        myList = customerList()
            .where((item) => favItems.contains(item['id'].toString()))
            .toList();
      });
      log(myList.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFavourits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0))),
        //  color: Colors.amberAccent,
        child: myList.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  return uicard(myList, index, context);
                },
              )
            : const Center(child: Text("No Data Found")),
      ),
    );
  }

  Widget uicard(
      List<Map<String, dynamic>> list, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetails(
                  data: list[index],
                  name: list[index]['name'],
                ),
              ));
        },
        child: Container(
          width: 150,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  // child: Image.network(list[index]['image']
                  child: Image.network(
                    list[index]['image'],
                    fit: BoxFit.fill,
                    height: 100,
                    width: MediaQuery.of(context).size.width * 1,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list[index]['name']),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lock_clock,
                              color: Colors.green,
                            ),
                            Text(list[index]['price'].toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 227, 214, 97),
                            ),
                            Text(list[index]['rating'].toString())
                          ],
                        ),
                      ],
                    ),
                    // Text(list[index]['price'].toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
