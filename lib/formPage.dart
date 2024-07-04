import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory/base_url.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  final Function refreshData;

  const FormPage({super.key, required this.refreshData});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController attrController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Buat Barang Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Masukkan Nama Barang",
              ),
            ),
            TextFormField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Masukkan jumlah barang",
              ),
            ),
            TextFormField(
              controller: attrController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Masukkan atribut",
              ),
            ),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Masukkan berat",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Uri url = Uri.parse("$baseUrl/stocks");

                final data = {
                  "name": nameController.text,
                  "qty": int.parse(qtyController.text),
                  "attr": attrController.text,
                  "weight": int.parse(weightController.text),
                };

                try {
                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(data),
                  );

                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Barang Berhasil ditambahkan"),
                      ),
                    );
                    widget.refreshData();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Gagal Menambahkan Barang: ${response.body}"),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Gagal Menambahkan Barang: Network error"),
                    ),
                  );
                }
              },
              child: Text("Kirim"),
            ),
          ],
        ),
      ),
    );
  }
}
