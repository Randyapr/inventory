import 'dart:convert';
import 'package:inventory/services/base_url.dart';
import 'package:inventory/services/data_sale.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Sale>> fetchSales() async {
    final response = await http.get(Uri.parse('$baseUrl/sales'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sale) => Sale.fromJson(sale)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sale> fetchSaleById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/sales/$id'));

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale');
    }
  }

  Future<void> createSale(
      String buyer, String phone, String date, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'buyer': buyer,
        'phone': phone,
        'date': date,
        'status': status,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to create sale. Status code: ${response.statusCode}');
    }
  }

  Future<void> saveProduction(
      String name, double price, int qty, String attr, double weight) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'price': price,
        'qty': qty,
        'attr': attr,
        'weight': weight,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Production saved successfully');
    } else {
      throw Exception(
          'Failed to save production. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteSale(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/sales/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to delete sale. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteProduction(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Production deleted successfully');
    } else {
      throw Exception(
          'Failed to delete production. Status code: ${response.statusCode}');
    }
  }
}
