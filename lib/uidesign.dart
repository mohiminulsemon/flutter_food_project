// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_food_project2/food_details.dart';
import 'package:flutter_food_project2/model/customer_list.dart';
// import 'package:flutter_food_project2/orders.dart';

class Uidesign extends StatefulWidget {
  const Uidesign({super.key});

  @override
  State<Uidesign> createState() => _UidesignState();
}

class _UidesignState extends State<Uidesign> {
  List<Map<String, dynamic>> customer_list = customerList();
  List<Map<String, dynamic>> search_list = customerList();

  void onQueryChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        search_list = customer_list;
      } else {
        search_list = customer_list
            .where((element) =>
                element['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.menu_book),
          )
        ],
      ),
      body: homePage(),
    );
  }

  Column homePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'search by name'),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.amberAccent,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(10.0))),
            //  color: Colors.amberAccent,
            child: search_list.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: search_list.length,
                    itemBuilder: (context, index) {
                      return uicard(search_list, index, context);
                    },
                  )
                : const Center(child: Text("No Data Found")),
          ),
        ),
      ],
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
