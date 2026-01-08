import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '485cacc4493fd838702f7bec01925c8c';
  final String baseUrl = 'https://v3.football.api-sports.io';

  final List<int> ligasVip = [
    39,
    140,
    262,
    253,
    2,
    135,
    78,
    61,
    143,
    9,
    137,
    13,
  ];

  // 1. OBTENER PARTIDOS
  Future<List<dynamic>> getMatches(DateTime fecha) async {
    try {
      String fechaFormateada = fecha.toIso8601String().split('T')[0];
      var url = Uri.parse('$baseUrl/fixtures?date=$fechaFormateada');
      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var todos = data['response'] as List;
        var filtrados = todos
            .where((p) => ligasVip.contains(p['league']['id']))
            .toList();
        filtrados.sort(
          (a, b) => a['fixture']['date'].compareTo(b['fixture']['date']),
        );
        return filtrados;
      } else {
        return [];
      }
    } catch (e) {
      print('Error matches: $e');
      return [];
    }
  }

  // 2. OBTENER GOLES
  Future<List<dynamic>> getMatchEvents(int fixtureId) async {
    try {
      var url = Uri.parse('$baseUrl/fixtures/events?fixture=$fixtureId');
      var response = await http.get(url, headers: {'x-apisports-key': apiKey});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 3. NUEVA FUNCIÓN: OBTENER TABLA DE POSICIONES
  Future<List<dynamic>> getStandings(int leagueId, int season) async {
    try {
      // Pedimos la tabla de esa liga y esa temporada
      var url = Uri.parse('$baseUrl/standings?league=$leagueId&season=$season');
      print('🔍 Buscando tabla: $url');

      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // La estructura es un poco compleja: response[0] -> league -> standings[0] (la tabla)
        if (data['response'].isNotEmpty) {
          return data['response'][0]['league']['standings'][0];
        }
      }
      return [];
    } catch (e) {
      print('Error tabla: $e');
      return [];
    }
  }
}
