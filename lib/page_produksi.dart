import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inventory/base_url.dart';

class PageProduksi extends StatefulWidget {
  const PageProduksi({super.key});

  @override
  State<PageProduksi> createState() => _PageProduksiState();
}

class _PageProduksiState extends State<PageProduksi> {
  List produk = [];
  List filteredProduk = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getProduk();
  }

  void getProduk() async {
    Uri url = Uri.parse("$baseUrl/products");
    final response = await http.get(url);
    setState(() {
      produk = jsonDecode(response.body);
      filteredProduk = produk;
    });
  }

  void filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProduk = produk.where((product) {
        return product['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produksi'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterProducts,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(filteredProduk[index]['imageUrl'] ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text(filteredProduk[index]['name']),
                    subtitle: Text('Harga: ${filteredProduk[index]['price']}'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke form produk baru
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
