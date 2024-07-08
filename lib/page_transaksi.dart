import 'package:flutter/material.dart';
import 'package:inventory/data_sale.dart';
import 'package:inventory/form_seller.dart';
import 'package:inventory/services/ApiService.dart';

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

  void _deleteSale(String id) async {
    await ApiService().deleteSale(id);
    setState(() {
      sales = ApiService().fetchSales();
    });
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
                    return sale.buyer
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(filteredSales[index].buyer,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Tanggal: ${filteredSales[index].date}\nStatus: ${filteredSales[index].status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteSale(filteredSales[index].id),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SaleDetail(id: filteredSales[index].id),
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
                createSale: (String buyer, String phone, String date,
                    String status) async {
                  await ApiService().createSale(buyer, phone, date, status);
                  setState(() {
                    sales = ApiService().fetchSales();
                  });
                },
                refreshData: () {
                  setState(() {
                    sales = ApiService().fetchSales();
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await ApiService().deleteSale(id);
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pop(); // Kembali ke halaman sebelumnya setelah menghapus
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

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
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
              ],
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
                      mainAxisSize: MainAxisSize.min,
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
