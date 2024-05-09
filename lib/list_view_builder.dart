import 'package:flutter/material.dart';

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  List<String> person = ['Semon','Shimon','Rahim','Minhaj','toha','ruma','shakil','arafat'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: person.length,
        itemBuilder: (BuildContext context, int index){
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/5677.jpg'),
              ),
              trailing: const Icon(Icons.phone),
              title: Text(person[index]),
            ),
          );
        },
      ),
    );
  }
}