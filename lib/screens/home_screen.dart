import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fondo Negro
      appBar: AppBar(
        title: const Text('ElevenHer'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // AQUÍ CAMBIAMOS DE PANTALLA
      body: _buildBody(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: const Color(0xFF8E44AD), // Morado ElevenHer
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Partidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ligas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // Lógica para cambiar entre las 3 pantallas
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const MatchesView(); // Partidos
      case 1:
        return const LeaguesView(); // Ligas (¡AHORA SÍ FUNCIONA!)
      case 2:
        return const ProfileView(); // Perfil
      default:
        return const MatchesView();
    }
  }
}

// ==========================================
// 1. PANTALLA DE PARTIDOS (MATCHES VIEW)
// ==========================================
class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          "Partidos de Hoy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        MatchCard(
          league: "Liga F",
          home: "Barcelona",
          away: "Real Madrid",
          score: "3 - 1",
          isLive: true,
        ),
        MatchCard(
          league: "NWSL",
          home: "Angel City",
          away: "San Diego",
          score: "19:00",
          isLive: false,
        ),
        MatchCard(
          league: "Liga MX",
          home: "Tigres",
          away: "Rayadas",
          score: "20:00",
          isLive: false,
        ),
        MatchCard(
          league: "WSL",
          home: "Chelsea",
          away: "Arsenal",
          score: "Mañana",
          isLive: false,
        ),
      ],
    );
  }
}

// ==========================================
// 2. PANTALLA DE LIGAS (LEAGUES VIEW - NUEVA)
// ==========================================
class LeaguesView extends StatelessWidget {
  const LeaguesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Competiciones",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Lista de Ligas
        _buildLeagueCard(
          Icons.public,
          "Champions League",
          "Europa",
          Colors.blue,
        ),
        _buildLeagueCard(Icons.flag, "Liga F", "España", Colors.red),
        _buildLeagueCard(Icons.star, "NWSL", "Estados Unidos", Colors.indigo),
        _buildLeagueCard(Icons.pets, "Liga MX Femenil", "México", Colors.green),
        _buildLeagueCard(Icons.shield, "WSL", "Inglaterra", Colors.purple),
        _buildLeagueCard(
          Icons.wb_sunny,
          "Copa Libertadores",
          "Sudamérica",
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildLeagueCard(
    IconData icon,
    String name,
    String country,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(country, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () {
          // Aquí podríamos navegar al detalle de la liga en el futuro
        },
      ),
    );
  }
}

// ==========================================
// 3. PANTALLA DE PERFIL (PROFILE VIEW)
// ==========================================
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF8E44AD),
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              SizedBox(width: 20),
              Column(
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
            ],
          ),
          const SizedBox(height: 30),
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
                _buildTeamCard("Barcelona", Colors.redAccent),
                _buildTeamCard("Chelsea W", Colors.blueAccent),
                _buildTeamCard("Angel City", Colors.pinkAccent),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Configuración",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(Icons.notifications, "Notificaciones", true),
          _buildSettingsTile(Icons.dark_mode, "Modo Oscuro", true),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String name, Color color) {
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

  Widget _buildSettingsTile(IconData icon, String title, bool isActive) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Icon(
        isActive ? Icons.toggle_on : Icons.toggle_off,
        color: isActive ? const Color(0xFF00E676) : Colors.grey,
        size: 40,
      ),
    );
  }
}

// ==========================================
// 4. TARJETA DE PARTIDO (REUTILIZABLE)
// ==========================================
class MatchCard extends StatelessWidget {
  final String league;
  final String home;
  final String away;
  final String score;
  final bool isLive;

  const MatchCard({
    super.key,
    required this.league,
    required this.home,
    required this.away,
    required this.score,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                league,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "EN VIVO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                home,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                score,
                style: const TextStyle(
                  color: Color(0xFF8E44AD),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                away,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
