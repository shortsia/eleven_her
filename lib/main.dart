import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const ElevenHerApp());
}

class ElevenHerApp extends StatelessWidget {
  const ElevenHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ElevenHer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo muy oscuro
        primaryColor: const Color(0xFF00FF87), // Verde Neón
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<dynamic> _partidos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPartidos();
  }

  void _cargarPartidos() async {
    print('⚽ Cargando partidos VIP en la pantalla...');

    // Llamamos a tu servicio (que ya tiene el filtro de ligas)
    var nuevosPartidos = await _apiService.getLiveMatches();

    setState(() {
      _partidos = nuevosPartidos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ElevenHer ⚽',
          style: TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _cargando = true;
              });
              _cargarPartidos();
            },
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00FF87)),
            )
          : _partidos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_soccer, size: 60, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    "No hay partidos VIP hoy",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _partidos.length,
              itemBuilder: (context, index) {
                var partido = _partidos[index];
                var equipoLocal = partido['teams']['home'];
                var equipoVisita = partido['teams']['away'];
                var goles = partido['goals'];
                var estado =
                    partido['fixture']['status']['short']; // Ej: FT, NS, 1H
                var liga = partido['league']; // Datos de la liga

                return Card(
                  color: const Color(0xFF1E1E1E), // Tarjeta gris oscura
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      // --- CABECERA DE LA LIGA (Nuevo Diseño) ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black26, // Cabecera más oscura
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Logo de la liga
                            Image.network(
                              liga['logo'],
                              height: 20,
                              width: 20,
                              errorBuilder: (c, o, s) => const Icon(
                                Icons.emoji_events,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Nombre de la liga
                            Expanded(
                              child: Text(
                                liga['name'].toString().toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),

                      // --- EL PARTIDO (EQUIPOS Y MARCADOR) ---
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // EQUIPO LOCAL
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                    equipoLocal['logo'],
                                    height: 50,
                                    errorBuilder: (c, o, s) => const Icon(
                                      Icons.shield,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    equipoLocal['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // MARCADOR CENTRAL
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    estado ?? "-",
                                    style: const TextStyle(
                                      color: Color(0xFF00FF87),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    child: Text(
                                      '${goles['home'] ?? 0} - ${goles['away'] ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // EQUIPO VISITA
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                    equipoVisita['logo'],
                                    height: 50,
                                    errorBuilder: (c, o, s) => const Icon(
                                      Icons.shield,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    equipoVisita['name'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
