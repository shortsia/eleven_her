import 'package:flutter/material.dart';
import '../screens/player_detail_screen.dart'; // Importamos la pantalla nueva

class LineupTab extends StatelessWidget {
  const LineupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "FC Barcelona (4-3-3)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),

        _buildSectionTitle("XI Inicial"),
        // Pasamos el "context" para poder navegar
        _buildPlayerRow(context, "1", "Sandra Paños", "GK"),
        _buildPlayerRow(context, "2", "Irene Paredes", "DEF"),
        _buildPlayerRow(context, "4", "Mapi León", "DEF"),
        _buildPlayerRow(context, "11", "Alexia Putellas", "MID"),
        _buildPlayerRow(context, "14", "Aitana Bonmatí", "MID"),
        _buildPlayerRow(context, "10", "C. Graham Hansen", "FWD"),

        const SizedBox(height: 20),

        _buildSectionTitle("Banquillo"),
        _buildPlayerRow(context, "13", "Cata Coll", "GK"),
        _buildPlayerRow(context, "7", "Salma Paralluelo", "FWD"),
      ],
    );
  }

  Widget _buildPlayerRow(
    BuildContext context,
    String number,
    String name,
    String position,
  ) {
    return GestureDetector(
      // Detecta el clic
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailScreen(
              name: name,
              number: number,
              position: position,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Hero(
              // Animación compartida con la siguiente pantalla
              tag: name,
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              position,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
