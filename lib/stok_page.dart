import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/base_url.dart';
import 'package:inventory/formPage.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPage();
}

class _StokPage extends State<StokPage> {
  List semuaBarang = [];

  void getSemuaBarang() async {
    Uri url = Uri.parse("$baseUrl/stocks");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var parsedResponse = jsonDecode(response.body);

      setState(() {
        semuaBarang = parsedResponse.reversed.toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void deleteBarang(String id) async {
    Uri url = Uri.parse("$baseUrl/stocks/$id");
    await http.delete(url);
    getSemuaBarang();
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
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getSemuaBarang();
        },
        child: ListView.builder(
          itemCount: semuaBarang.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(semuaBarang[index]['qty'].toString(),
                      style: TextStyle(color: Colors.white)),
                ),
                title: Text(semuaBarang[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(semuaBarang[index]['attr']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      deleteBarang(semuaBarang[index]['id'].toString()),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FormPage(refreshData: getSemuaBarang)),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
