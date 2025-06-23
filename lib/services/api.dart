import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/customer.dart';

class ApiService {
  static const String baseUrl = 'http://aipel-cdn.polbeng.my.id/api';

  static Future<Map<String, dynamic>> login(
    String login,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'login': login, 'password': password},
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['access_token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['access_token']);
      prefs.setString('user', json.encode(data['user']));
      return {'success': true};
    }

    return {'success': false, 'message': data['message'] ?? 'Login gagal'};
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    prefs.clear();
  }

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  static Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['data'];
      return list.map((e) => Customer.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data kontak');
    }
  }

  static Future<Customer> getCustomerById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/customers/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Customer.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat data kontak dengan ID $id');
    }
  }

  static Future<Map<String, dynamic>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updateCustomer(
    int id,
    Map<String, dynamic> body,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: body,
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deleteCustomer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/customers/$id'));

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      final body = json.decode(response.body);
      return {
        'success': false,
        'message':
            body['message'] ?? 'Terjadi kesalahan saat menghapus kontak.',
      };
    }
  }
}
