import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '485cacc4493fd838702f7bec01925c8c';
  final String baseUrl = 'https://v3.football.api-sports.io';

  // LISTA VIP: Ligas importantes
  final List<int> ligasVip = [
    39, // Premier League
    140, // La Liga
    262, // Liga MX
    253, // MLS
    2, // Champions League
    135, // Serie A
    78, // Bundesliga
    61, // Ligue 1
    143, // Copa del Rey
    9, // Selecciones
    137, // Copa Sudamericana
    13, // Copa Libertadores
  ];

  // AHORA RECIBIMOS LA FECHA COMO PARÁMETRO
  Future<List<dynamic>> getMatches(DateTime fecha) async {
    try {
      // Convertimos la fecha al formato que quiere la API: "2025-06-14"
      String fechaFormateada = fecha.toIso8601String().split('T')[0];

      print('📅 Buscando partidos VIP para la fecha: $fechaFormateada');

      var url = Uri.parse('$baseUrl/fixtures?date=$fechaFormateada');

      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var todosLosPartidos = data['response'] as List;

        // FILTRO VIP
        var partidosFiltrados = todosLosPartidos.where((partido) {
          int idLiga = partido['league']['id'];
          return ligasVip.contains(idLiga);
        }).toList();

        // ORDENAR POR HORA (Para que salgan en orden cronológico)
        partidosFiltrados.sort((a, b) {
          String horaA = a['fixture']['date'];
          String horaB = b['fixture']['date'];
          return horaA.compareTo(horaB);
        });

        return partidosFiltrados;
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
