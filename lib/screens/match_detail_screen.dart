import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Importamos el servicio para pedir los goles

class MatchDetailScreen extends StatefulWidget {
  final dynamic partido;

  const MatchDetailScreen({super.key, required this.partido});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _eventos = []; // Aquí guardaremos los goles
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDetalles();
  }

  // Pedimos los goles a la API usando el ID del partido
  void _cargarDetalles() async {
    int idPartido = widget.partido['fixture']['id'];
    var eventosEncontrados = await _apiService.getMatchEvents(idPartido);

    // Solo nos interesan Goles y Tarjetas Rojas (filtramos lo demás)
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

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

            // --- SECCIÓN DE GOLES Y EVENTOS ---
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "EVENTOS DEL PARTIDO",
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
                      "No hay datos de goles disponibles.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap:
                        true, // Importante para que funcione dentro del Column
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _eventos.length,
                    itemBuilder: (context, index) {
                      var evento = _eventos[index];
                      var equipo = evento['team']['name'];
                      var jugador = evento['player']['name'];
                      var minuto = evento['time']['elapsed'];
                      var tipo = evento['type']; // 'Goal' o 'Card'
                      var esGol = tipo == 'Goal';

                      // ¿Fue el equipo local? (Para ponerlo a la izquierda o derecha)
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
                            // Si es visita, ponemos espacio vacío a la izquierda
                            if (!esLocal) const Spacer(),

                            // LA CAJITA DEL EVENTO
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
                                    esGol
                                        ? Icons.sports_soccer
                                        : Icons.style, // Balón o Tarjeta
                                    color: esGol
                                        ? Colors.white
                                        : Colors.red, // Blanco o Rojo
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),

                            // Si es local, ponemos espacio vacío a la derecha
                            if (esLocal) const Spacer(),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 20),

            // --- FICHA TÉCNICA (Info Extra) ---
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
