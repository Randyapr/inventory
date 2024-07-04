import 'dart:convert';

import 'package:inventory/data_sale.dart';
import 'package:http/http.dart' as http;


class ApiService {
  Future<List<Sale>> fetchSales() async {
    final response = await http.get(Uri.parse('https://api.kartel.dev/sales'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sale) => Sale.fromJson(sale)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sale> fetchSaleById(String id) async {
    final response = await http.get(Uri.parse('https://api.kartel.dev/sales/$id'));

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale');
    }
  }
}
