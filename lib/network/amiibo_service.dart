import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_pam/models/amiibo_model.dart';


class AmiiboService {
  final String baseUrl = 'http://amiiboapi.com/api/amiibo';

  // Fetch Amiibo by head
  Future<Amiibo> getAmiiboByHead(String head) async {
    final response = await http.get(Uri.parse('$baseUrl/?head=$head'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['amiibo'][0];  
      return Amiibo.fromJson(data);  
    } else {
      throw Exception('Failed to load amiibo');  
    }
  }
}
