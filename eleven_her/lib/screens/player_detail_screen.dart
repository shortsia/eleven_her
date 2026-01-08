import 'package:flutter/material.dart';

class PlayerDetailScreen extends StatelessWidget {
  final String name;
  final String number;
  final String position;

  const PlayerDetailScreen({
    super.key,
    required this.name,
    required this.number,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: Text(name), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // FOTO DE PERFIL (Círculo grande)
            Hero(
              tag: name, // Esto hará una animación bonita al entrar
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: const Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),

            // NOMBRE Y DORSAL
            Text(
              "#$number $name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              position == "FWD"
                  ? "Delantera"
                  : (position == "MID" ? "Mediocampista" : "Defensa"),
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            // TARJETAS DE ESTADÍSTICAS (GRID)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap:
                    true, // Importante para que funcione dentro de Column
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 columnas
                childAspectRatio: 1.5, // Forma rectangular
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard("Partidos", "18", Icons.sports_soccer),
                  _buildStatCard("Goles", "12", Icons.emoji_events),
                  _buildStatCard("Asistencias", "8", Icons.compare_arrows),
                  _buildStatCard("Minutos", "1,420", Icons.timer),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN DE SEGUIR
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_active),
                label: const Text("Seguir Jugadora"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // Ancho completo
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[400], size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
