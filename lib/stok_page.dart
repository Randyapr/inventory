import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/formPage.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPage();
}

class _StokPage extends State<StokPage> {
  List SemuaBarang = [];

  void getSemuaBarang() async{
    Uri url = Uri.parse("$baseUrl/posts");
    final response = await http.get(url);

    setState(() {
      SemuaBarang = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    getSemuaBarang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stok"),
      ),
      body: ListView.builder(
        itemCount: SemuaBarang.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Text(SemuaBarang[index]['userId'].toString()),
              title: Text(SemuaBarang[index]['title']),
              subtitle: Text(SemuaBarang[index]['body']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => formPage()),
            );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}