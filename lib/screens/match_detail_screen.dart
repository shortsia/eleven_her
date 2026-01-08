import 'package:flutter/material.dart';

class MatchDetailScreen extends StatelessWidget {
  // Aquí recibimos todos los datos del partido que tocaste
  final dynamic partido;

  const MatchDetailScreen({super.key, required this.partido});

  @override
  Widget build(BuildContext context) {
    // Sacamos los datos para usarlos fácil
    var local = partido['teams']['home'];
    var visita = partido['teams']['away'];
    var goles = partido['goals'];
    var liga = partido['league'];
    var info = partido['fixture']; // Aquí está el estadio, árbitro, fecha...
    var estado =
        partido['fixture']['status']['long']; // Estado completo (ej: Match Finished)

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Botón para regresar
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

            // --- MARCADOR GIGANTE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // LOCAL
                Column(
                  children: [
                    Image.network(local['logo'], height: 80),
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
                // GOLES
                Text(
                  '${goles['home'] ?? 0} - ${goles['away'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF87),
                  ),
                ),
                // VISITA
                Column(
                  children: [
                    Image.network(visita['logo'], height: 80),
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
            const SizedBox(height: 30),

            // --- TARJETA DE INFORMACIÓN (ESTADIO, HORA, ETC) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _filaDetalle(
                    Icons.stadium,
                    "Estadio",
                    info['venue']['name'] ?? "Por definir",
                  ),
                  const Divider(color: Colors.black45),
                  _filaDetalle(
                    Icons.location_on,
                    "Ciudad",
                    info['venue']['city'] ?? "Desconocida",
                  ),
                  const Divider(color: Colors.black45),
                  _filaDetalle(
                    Icons.sports,
                    "Árbitro",
                    info['referee'] ?? "No asignado",
                  ),
                  const Divider(color: Colors.black45),
                  _filaDetalle(
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

  // Una pequeña fábrica de filas para no repetir código
  Widget _filaDetalle(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF00FF87), size: 20),
          const SizedBox(width: 15),
          Text(titulo, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
