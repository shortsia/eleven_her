import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '485cacc4493fd838702f7bec01925c8c';
  final String baseUrl = 'https://v3.football.api-sports.io';

  // LISTA VIP: Solo dejaremos pasar partidos de estas ligas
  final List<int> ligasVip = [
    39, // Premier League
    140, // La Liga (España)
    262, // Liga MX
    253, // MLS
    2, // Champions League
    135, // Serie A (Italia)
    78, // Bundesliga (Alemania)
    61, // Ligue 1 (Francia)
    143, // Copa del Rey (A veces hay partidos entre semana)
    9, // Partidos de Selecciones (Copa América/Mundial)
  ];

  Future<List<dynamic>> getLiveMatches() async {
    try {
      // 1. Fecha de hoy
      String fechaHoy = DateTime.now().toString().split(' ')[0];
      print('📅 Buscando partidos VIP para: $fechaHoy');

      var url = Uri.parse('$baseUrl/fixtures?date=$fechaHoy');

      var response = await http.get(url, headers: {'x-apisports-key': apiKey});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var todosLosPartidos = data['response'] as List;

        // --- AQUI OCURRE EL FILTRO MÁGICO ---
        var partidosFiltrados = todosLosPartidos.where((partido) {
          // Buscamos el ID de la liga de este partido
          int idLiga = partido['league']['id'];
          // ¿Está este ID en nuestra lista VIP?
          return ligasVip.contains(idLiga);
        }).toList();
        // ------------------------------------

        print(
          '🧹 Limpieza completada: De ${todosLosPartidos.length} partidos, quedaron ${partidosFiltrados.length} VIP.',
        );

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
