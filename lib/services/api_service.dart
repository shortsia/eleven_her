import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '485cacc4493fd838702f7bec01925c8c';
  final String baseUrl = 'https://v3.football.api-sports.io';

  Future<List<dynamic>> getLiveMatches() async {
    try {
      // 1. Obtenemos la fecha de hoy (YYYY-MM-DD)
      String fechaHoy = DateTime.now().toString().split(' ')[0];
      print('📅 Buscando partidos para la fecha: $fechaHoy');

      // 2. Construimos la URL
      var url = Uri.parse('$baseUrl/fixtures?date=$fechaHoy');
      print('🔍 URL SOLICITADA: $url');

      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['response'];
      } else {
        print('Error de conexión: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error grave: $e');
      return [];
    }
  }
}
