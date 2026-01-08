import 'package:flutter/material.dart';

class StandingsScreen extends StatelessWidget {
  final String leagueName;

  const StandingsScreen({super.key, required this.leagueName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tabla - $leagueName"), elevation: 0),
      body: Column(
        children: [
          // Cabecera de la tabla
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFF2A2A2A),
            child: const Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    "#",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Equipo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    "PJ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    "DG",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    "Pts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de equipos
          Expanded(
            child: ListView(
              children: [
                _buildRow(
                  1,
                  "Barcelona F",
                  18,
                  56,
                  54,
                  true,
                ), // Líder (Champions)
                _buildRow(2, "Real Madrid F", 18, 25, 43, true), // Champions
                _buildRow(3, "Levante", 18, 15, 38, true),
                _buildRow(4, "Madrid CFF", 18, 8, 35, false),
                _buildRow(5, "Atlético Madrid", 18, 12, 32, false),
                _buildRow(6, "Sevilla", 18, -2, 29, false),
                _buildRow(7, "Athletic Club", 18, -5, 24, false),
                _buildRow(8, "Costa Adeje", 18, -8, 20, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    int pos,
    String team,
    int played,
    int gd,
    int pts,
    bool isChampions,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // Posición (con color si va a Champions)
          SizedBox(
            width: 30,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isChampions
                    ? const Color(0xFF00E676).withOpacity(0.2)
                    : null, // Verde si es Champions
                shape: BoxShape.circle,
              ),
              child: Text(
                pos.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isChampions ? const Color(0xFF00E676) : Colors.white,
                ),
              ),
            ),
          ),

          // Nombre Equipo
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.shield, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(team, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          // Estadísticas
          SizedBox(
            width: 30,
            child: Text(
              played.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              gd > 0 ? "+$gd" : gd.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              pts.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
