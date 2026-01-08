import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // CABECERA
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF8E44AD),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Usuario ElevenHer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Fanático del Fútbol",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            // MIS EQUIPOS
            const Text(
              "Mis Equipos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFavoriteTeamCard("Barcelona", Colors.redAccent),
                  _buildFavoriteTeamCard("Chelsea W", Colors.blueAccent),
                  _buildFavoriteTeamCard("Angel City", Colors.pinkAccent),
                  _buildAddButton(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // JUGADORAS
            const Text(
              "Jugadoras",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildPlayerTile("Alexia Putellas", "FC Barcelona", "11"),
            _buildPlayerTile("Sam Kerr", "Chelsea", "20"),
            _buildPlayerTile("Aitana Bonmatí", "FC Barcelona", "14"),

            const SizedBox(height: 30),

            // AJUSTES
            const Text(
              "Ajustes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSettingsTile(
              Icons.notifications,
              "Notificaciones de Goles",
              true,
            ),
            _buildSettingsTile(Icons.dark_mode, "Modo Oscuro", true),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteTeamCard(String name, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
        // CORRECCIÓN AQUÍ: Quitamos 'dashed' y dejamos el borde normal (solid)
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: const Icon(Icons.add, color: Colors.grey),
    );
  }

  Widget _buildPlayerTile(String name, String team, String number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CircleAvatar(
          backgroundColor: Colors.white10,
          child: Text(number, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          team,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.star, color: Color(0xFF8E44AD)),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, bool isActive) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: isActive
          ? const Icon(Icons.toggle_on, color: Color(0xFF00E676), size: 40)
          : const Icon(Icons.toggle_off, color: Colors.grey, size: 40),
    );
  }
}
