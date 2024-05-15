// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_food_project2/favourites.dart';
import 'package:flutter_food_project2/food_details.dart';
import 'package:flutter_food_project2/model/customer_list.dart';


class Uidesign extends StatefulWidget {
  const Uidesign({super.key});

  @override
  State<Uidesign> createState() => _UidesignState();
}

class _UidesignState extends State<Uidesign> {
  List<Map<String, dynamic>> customer_list = customerList();
  List<Map<String, dynamic>> search_list = customerList();
  List<Map<String, dynamic>> salad =
      customerList().where((element) => element['type'] == 'Salads').toList();
  List<Map<String, dynamic>> drinks =
      customerList().where((element) => element['type'] == 'Drinks').toList();
  List<Map<String, dynamic>> sauce =
      customerList().where((element) => element['type'] == 'Sauce').toList();
  List<Map<String, dynamic>> setMenu =
      customerList().where((element) => element['type'] == 'Set Menu').toList();
  List<Map<String, dynamic>> fastFood = customerList()
      .where((element) => element['type'] == 'Fast Food')
      .toList();
  List<Map<String, dynamic>> dessert =
      customerList().where((element) => element['type'] == 'Dessert').toList();

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
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Menu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
                // Navigate to MyFavourite page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyFavourites()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.favorite_rounded),
              ),
            ),
          ],
        ),
        body: homePage(),
      ),
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TabBar(isScrollable: true, tabs: [
            Tab(text: 'All'),
            Tab(text: 'Salads'),
            Tab(text: 'Drinks'),
            Tab(text: 'Sauce'),
            Tab(text: 'Set Menu'),
            Tab(text: 'Fast Food'),
            Tab(text: 'Dessert'),
          ]),
        ),
        Expanded(
            child: TabBarView(
          children: [
            buildGridView(search_list),
            buildGridView(salad), // Salads tab view
            buildGridView(drinks), // Drinks tab view
            buildGridView(sauce), // Sauce tab view
            buildGridView(setMenu), // Set Menu tab view
            buildGridView(fastFood), // Fast Food tab view
            buildGridView(dessert),
          ],
        ))
      ],
    );
  }

  Container buildGridView(List<Map<String, dynamic>> list) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0))),
      //  color: Colors.amberAccent,
      child: list.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return uicard(list, index, context);
              },
            )
          : const Center(child: Text("No Data Found")),
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
