import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/spell_model.dart';

class ApiService {
  static const String _baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('$_baseUrl/books'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data buku (${response.statusCode})');
    }
  }

  static Future<List<Spell>> getSpells() async {
    final response = await http.get(Uri.parse('$_baseUrl/spells'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Spell.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data sihir (${response.statusCode})');
    }
  }
}
