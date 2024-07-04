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

  SaleDetail({required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sale>(
      future: ApiService().fetchSaleById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('Data not found.'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.buyer),
              backgroundColor: Colors.teal,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Buyer: ${snapshot.data!.buyer}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Phone: ${snapshot.data!.phone}'),
                  SizedBox(height: 8),
                  Text('Date: ${snapshot.data!.date}'),
                  SizedBox(height: 8),
                  Text('Status: ${snapshot.data!.status}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
