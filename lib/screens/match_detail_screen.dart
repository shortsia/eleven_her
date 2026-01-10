import 'package:flutter/material.dart';

class MatchDetailScreen extends StatelessWidget {
  final dynamic partido;

  const MatchDetailScreen({super.key, required this.partido});

  @override
  Widget build(BuildContext context) {
    // Extraemos los datos para no escribir tanto abajo
    var local = partido['teams']['home'];
    var visita = partido['teams']['away'];
    var goles = partido['goals'];
    var liga = partido['league'];
    var info = partido['fixture'];
    var estadio = info['venue'];

    // Formatear estado
    String estado = info['status']['long'];
    String minuto = info['status']['elapsed']?.toString() ?? "";
    bool enVivo = [
      '1H',
      'HT',
      '2H',
      'ET',
      'P',
    ].contains(info['status']['short']);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          liga['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TARJETA DEL MARCADOR (Estilo TV) ---
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E1E), Colors.grey.shade900],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF87).withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // LIGA Y RONDA
                  Text(
                    "${liga['round'] ?? ''}".toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ESCUDOS Y MARCADOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // LOCAL
                      Expanded(
                        child: Column(
                          children: [
                            Hero(
                              // Animación de vuelo
                              tag: 'logo_${local['id']}',
                              child: Image.network(
                                local['logo'],
                                height: 80,
                                errorBuilder: (c, o, s) => const Icon(
                                  Icons.shield,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              local['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // MARCADOR CENTRAL
                      Column(
                        children: [
                          Text(
                            "${goles['home'] ?? 0} : ${goles['away'] ?? 0}",
                            style: const TextStyle(
                              color: Color(0xFF00FF87),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (enVivo)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "LIVE $minuto'",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          else
                            Text(
                              estado,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),

                      // VISITA
                      Expanded(
                        child: Column(
                          children: [
                            Hero(
                              // Animación de vuelo
                              tag: 'logo_${visita['id']}',
                              child: Image.network(
                                visita['logo'],
                                height: 80,
                                errorBuilder: (c, o, s) => const Icon(
                                  Icons.shield,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              visita['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- TARJETAS DE INFORMACIÓN (Estadio, Árbitro) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "INFORMACIÓN DEL PARTIDO",
                    style: TextStyle(
                      color: Color(0xFF00FF87),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tarjeta Estadio
                  _buildInfoCard(
                    Icons.stadium,
                    "Estadio",
                    "${estadio['name'] ?? 'Por definir'}",
                    "${estadio['city'] ?? ''}",
                  ),

                  const SizedBox(height: 12),

                  // Tarjeta Árbitro
                  _buildInfoCard(
                    Icons.sports,
                    "Árbitro",
                    "${info['referee'] ?? 'Sin asignar'}",
                    "Juez Central",
                  ),

                  const SizedBox(height: 12),

                  // Tarjeta Fecha
                  _buildInfoCard(
                    Icons.calendar_today,
                    "Fecha y Hora",
                    info['date'].toString().substring(0, 10),
                    info['date'].toString().substring(11, 16) + " Horas",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Una pequeña fábrica de tarjetas para no repetir código
  Widget _buildInfoCard(
    IconData icon,
    String title,
    String data,
    String subdata,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00FF87), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  data,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (subdata.isNotEmpty)
                  Text(
                    subdata,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
