import 'package:flutter/material.dart';
import '../widgets/lineup_tab.dart'; // <--- ESTA LÍNEA ES CLAVE. Conecta los archivos.

class MatchDetailScreen extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String score;

  const MatchDetailScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detalle del Partido"),
          bottom: const TabBar(
            indicatorColor: Color(0xFF8E44AD),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Resumen"),
              Tab(text: "Estadísticas"),
              Tab(text: "Alineaciones"),
            ],
          ),
        ),
        body: Column(
          children: [
            // Cabecera del marcador
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF1F1F1F),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.shield, size: 50, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        homeTeam,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    score,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00E676),
                    ),
                  ),
                  Column(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        awayTeam,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CONTENIDO DE LAS PESTAÑAS
            const Expanded(
              child: TabBarView(
                children: [
                  // Pestaña 1
                  Center(child: Text("Aquí irán los goles y tarjetas")),

                  // Pestaña 2
                  Center(child: Text("Aquí irán Posesión y Tiros")),

                  // Pestaña 3: Aquí llamamos al archivo nuevo
                  LineupTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
