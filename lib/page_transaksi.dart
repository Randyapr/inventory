import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory/data_sale.dart';
import 'package:inventory/form_seller.dart';
import 'package:inventory/services/ApiService.dart';
import 'package:http/http.dart' as http;

class PageTransaksi extends StatefulWidget {
  @override
  _PageTransaksiState createState() => _PageTransaksiState();
}

class _PageTransaksiState extends State<PageTransaksi> {
  late Future<List<Sale>> sales;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    sales = ApiService().fetchSales();
  }

  Future<void> createSale(
      String buyer, String phone, String date, String status) async {
    final response = await http.post(
      Uri.parse('https://api.kartel.dev/sales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        sales = ApiService().fetchSales(); // Refresh sales list after adding new sale
      });
    } else {
      throw Exception('Failed to create sale. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Penjualan'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Buyer...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Sale>>(
              future: sales,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data penjualan.'));
                } else {
                  final filteredSales = snapshot.data!.where((sale) {
                    return sale.buyer.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(filteredSales[index].buyer, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Tanggal: ${filteredSales[index].date}\nStatus: ${filteredSales[index].status}'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SaleDetail(id: filteredSales[index].id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormSeller(
                createSale: createSale,
                refreshData: () {
                  setState(() {
                    sales = ApiService().fetchSales(); // Refresh sales list after adding new sale
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}

class SaleDetail extends StatelessWidget {
  final String id;

  const SaleDetail({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sale>(
      future: ApiService().fetchSaleById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Penjualan'),
              backgroundColor: Colors.teal,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Penjualan'),
              backgroundColor: Colors.teal,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail Penjualan'),
              backgroundColor: Colors.teal,
            ),
            body: const Center(child: Text('Data tidak ditemukan')),
          );
        } else {
          final sale = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Detail Penjualan: ${sale.buyer}'),
              backgroundColor: Colors.teal,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Make the column as small as possible
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.teal),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pembeli: ${sale.buyer}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.teal),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Telepon: ${sale.phone}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.teal),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tanggal: ${sale.date}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.teal),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Status: ${sale.status}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}