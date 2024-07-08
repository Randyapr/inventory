import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/services/ApiService.dart';
import 'dart:convert';
import 'form_produksi.dart';
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
  final ApiService apiService = ApiService();

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

  Future<void> saveProduction(String name, double price, int qty, String attr, double weight) async {
    try {
      await apiService.saveProduction(name, price, qty, attr, weight);
      getProduk();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan produksi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteProduction(String id) async {
    try {
      await apiService.deleteProduction(id);
      getProduk();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus produksi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigateToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormProduksi(
          saveProduction: saveProduction,
          refreshData: getProduk,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produksi'),
        backgroundColor: Colors.teal,
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProduction(filteredProduk[index]['id'].toString()),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToForm,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
