import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'standings_screen.dart'; // <--- IMPORTANTE: Importamos la pantalla de tabla

class MatchDetailScreen extends StatefulWidget {
  final dynamic partido;

  const MatchDetailScreen({super.key, required this.partido});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _eventos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDetalles();
  }

  void _cargarDetalles() async {
    int idPartido = widget.partido['fixture']['id'];
    var eventosEncontrados = await _apiService.getMatchEvents(idPartido);

    var eventosImportantes = eventosEncontrados.where((e) {
      return e['type'] == 'Goal' || e['detail'] == 'Red Card';
    }).toList();

    if (mounted) {
      setState(() {
        _eventos = eventosImportantes;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = widget.partido['teams']['home'];
    var visita = widget.partido['teams']['away'];
    var goles = widget.partido['goals'];
    var liga = widget.partido['league'];
    var info = widget.partido['fixture'];
    var estado = widget.partido['fixture']['status']['long'];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          liga['name'],
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          // --- BOTÓN NUEVO: VER TABLA ---
          IconButton(
            icon: const Icon(Icons.table_chart, color: Color(0xFF00FF87)),
            onPressed: () {
              // Navegar a la pantalla de Tabla
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StandingsScreen(
                    leagueId: liga['id'],
                    season: liga['season'], // Pasamos el año de la temporada
                    leagueName: liga['name'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- BOTÓN GRANDE PARA VER TABLA (OPCIONAL) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StandingsScreen(
                        leagueId: liga['id'],
                        season: liga['season'],
                        leagueName: liga['name'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.emoji_events, color: Colors.black),
                label: const Text("VER TABLA DE POSICIONES"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF87),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- MARCADOR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.network(local['logo'], height: 70),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Text(
                        local['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${goles['home'] ?? 0} - ${goles['away'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF87),
                  ),
                ),
                Column(
                  children: [
                    Image.network(visita['logo'], height: 70),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Text(
                        visita['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(estado, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),
            const Divider(color: Colors.grey),

            // --- EVENTOS ---
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "EVENTOS",
                style: TextStyle(
                  color: Color(0xFF00FF87),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            _cargando
                ? const CircularProgressIndicator(color: Color(0xFF00FF87))
                : _eventos.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Sin eventos registrados.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _eventos.length,
                    itemBuilder: (context, index) {
                      var evento = _eventos[index];
                      var jugador = evento['player']['name'];
                      var minuto = evento['time']['elapsed'];
                      var tipo = evento['type'];
                      var esGol = tipo == 'Goal';
                      bool esLocal = (evento['team']['id'] == local['id']);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: esLocal
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (!esLocal) const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade800),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "$minuto' ",
                                    style: const TextStyle(
                                      color: Color(0xFF00FF87),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    jugador,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    esGol ? Icons.sports_soccer : Icons.style,
                                    color: esGol ? Colors.white : Colors.red,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            if (esLocal) const Spacer(),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _fila(
                    Icons.stadium,
                    "Estadio",
                    info['venue']['name'] ?? "Por definir",
                  ),
                  const SizedBox(height: 10),
                  _fila(
                    Icons.calendar_today,
                    "Fecha",
                    info['date'].toString().substring(0, 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
