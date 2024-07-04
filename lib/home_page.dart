import 'package:flutter/material.dart';
import 'package:inventory/page_transaksi.dart';
import 'package:inventory/stok_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-photo/variety-people-multitasking-3d-cartoon-scene_23-2151294536.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Halaman Home',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Selamat datang di aplikasi inventory Saya!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to another page, e.g., sales page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageTransaksi()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Lihat Daftar Penjualan'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                     onPressed: () {
                      // Navigate to another page, e.g., sales page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StokPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Lihat Daftar Stok'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
