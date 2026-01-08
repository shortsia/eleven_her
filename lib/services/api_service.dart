import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '485cacc4493fd838702f7bec01925c8c';
  final String baseUrl = 'https://v3.football.api-sports.io';

  // LISTA VIP
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

  // 1. OBTENER LISTA DE PARTIDOS
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
      print('Error: $e');
      return [];
    }
  }

  // --- NUEVA FUNCIÓN: OBTENER LOS GOLES Y EVENTOS DE UN PARTIDO ---
  Future<List<dynamic>> getMatchEvents(int fixtureId) async {
    try {
      // Pedimos específicamente los eventos de ESTE partido ID
      var url = Uri.parse('$baseUrl/fixtures/events?fixture=$fixtureId');

      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['response']; // Devolvemos la lista de goles/tarjetas
      } else {
        return [];
      }
    } catch (e) {
      print('Error eventos: $e');
      return [];
    }
  }
}
