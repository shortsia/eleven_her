import 'package:flutter/material.dart';

// --- PANTALLA PRINCIPAL (MODO RESCATE) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Función para construir la pantalla según el menú
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildMatchesList();
      case 1:
        return const Center(
          child: Text(
            "Ligas (Próximamente)",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            "Perfil (Próximamente)",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      default:
        return _buildMatchesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElevenHer'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F), // Color gris oscuro
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF121212), // Fondo negro

      body: _buildBody(),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: const Color(0xFF8E44AD),
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

  // Lista de Partidos (Interna, sin archivos externos)
  Widget _buildMatchesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Partidos de Hoy",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),

        // Tarjeta 1
        _buildSimpleCard("Liga F", "Barcelona", "Real Madrid", "3 - 1", true),
        // Tarjeta 2
        _buildSimpleCard("NWSL", "Angel City", "San Diego", "19:00", false),
        // Tarjeta 3
        _buildSimpleCard("Liga MX", "Tigres", "Rayadas", "20:00", false),
      ],
    );
  }

  // Diseño de la tarjeta (Para que no falle buscando archivos)
  Widget _buildSimpleCard(
    String league,
    String home,
    String away,
    String score,
    bool isLive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
