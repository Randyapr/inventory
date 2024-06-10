import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory/base_url.dart';
import 'package:http/http.dart' as http;

class formPage extends StatefulWidget {
  const formPage({super.key});

  @override
  State<formPage> createState() => _formPage();
}

class _formPage extends State<formPage> {
  TextEditingController idUserController = TextEditingController();
  TextEditingController TitleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FORM BUAT BARANG BARU"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextFormField(
            controller: idUserController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Masukkan ID text",
            ),
          ),
          TextFormField(
            controller: TitleController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Masukkan Title text",
            ),
          ),
          TextFormField(
            controller: bodyController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Masukkan text",
            ),
          ),
          FilledButton(
              onPressed: () async {
                Uri url = Uri.parse("$baseUrl/posts");

                final data = {
                  "userId": int.parse(idUserController.text),
                  "title": TitleController.text,
                  "body": bodyController.text,
                };

                final response = await http.post(url, body: jsonEncode(data));

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Barang Berhasil di tambahkan"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Gagal Menambahkan Barang"),
                    ),
                  );
                }
              },
              child: Text("KIRIM")),
        ]),
      ),
    );
  }
}
