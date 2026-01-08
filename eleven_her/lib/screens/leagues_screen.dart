import 'package:flutter/material.dart';
import 'standings_screen.dart'; // Importamos la tabla nueva

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Competiciones",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          _buildLeagueCard(context, "Liga F", "España", Colors.orangeAccent),
          _buildLeagueCard(context, "NWSL", "USA", Colors.blueAccent),
          _buildLeagueCard(context, "WSL", "Inglaterra", Colors.purpleAccent),
          _buildLeagueCard(
            context,
            "Champions League",
            "Europa",
            Colors.indigoAccent,
          ),
          _buildLeagueCard(
            context,
            "Liga MX Femenil",
            "México",
            Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueCard(
    BuildContext context,
    String name,
    String country,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white10,
          child: Text(name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(country, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          // NAVEGACIÓN A LA TABLA
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StandingsScreen(leagueName: name),
            ),
          );
        },
      ),
    );
  }
}
