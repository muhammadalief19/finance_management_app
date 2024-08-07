import 'package:flutter/foundation.dart';
import 'package:hitung_keuangan/model/model_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static const String baseUrl =
      'http://192.168.208.40:8000/api'; // Ganti dengan URL API Anda

  Future<int?> cekDataPemasukan() async {
    final response = await http.get(Uri.parse('$baseUrl/cekDataPemasukan'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<int?> cekDataPengeluaran() async {
    final response = await http.get(Uri.parse('$baseUrl/cekDataPengeluaran'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<int?> saveData(ModelDatabase modelDatabase) async {
    final response = await http.post(
      Uri.parse('$baseUrl/saveData'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(modelDatabase.toJson()),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body)[
          'id']; // Asumsikan API mengembalikan ID dari data yang disimpan
    }
    debugPrint(response.toString());
    return null;
  }

  Future<List?> getDataPemasukan() async {
    final response = await http.get(Uri.parse('$baseUrl/getDataPemasukan'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<List?> getDataPengeluaran() async {
    final response = await http.get(Uri.parse('$baseUrl/getDataPengeluaran'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<int?> getJmlPemasukan() async {
    final response = await http.get(Uri.parse('$baseUrl/getJmlPemasukan'));
    if (response.statusCode == 200) {
      String total = jsonDecode(response.body)['total'];
      return int.parse(total);
    }
    return 0;
  }

  Future<int?> getJmlPengeluaran() async {
    final response = await http.get(Uri.parse('$baseUrl/getJmlPengeluaran'));
    if (response.statusCode == 200) {
      String total = jsonDecode(response.body)['total'];
      return int.parse(total);
    }
    return 0;
  }

  Future<int?> updateData(ModelDatabase modelDatabase) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateData/${modelDatabase.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(modelDatabase.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['updated'];
    }
    return null;
  }

  Future<int?> deleteData(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['deleted'];
    }
    return null;
  }
}
