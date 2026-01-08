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
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF00FF87),
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

  // Aquí guardaremos la lista de partidos cuando lleguen de internet
  List<dynamic> _partidos = [];
  bool _cargando = true; // Para saber si mostramos el círculo de carga

  @override
  void initState() {
    super.initState();
    _cargarPartidos();
  }

  // Función para pedir datos y actualizar la pantalla
  void _cargarPartidos() async {
    print('⚽ Cargando partidos en la pantalla...');

    var nuevosPartidos = await _apiService.getLiveMatches();

    // setState es la MAGIA: Avisa a Flutter que debe repintar la pantalla
    setState(() {
      _partidos = nuevosPartidos;
      _cargando = false; // Dejamos de cargar
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
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _cargando = true;
              });
              _cargarPartidos();
            },
          ),
        ],
      ),
      // EL CUERPO DE LA APP CAMBIA DEPENDIENDO DE LOS DATOS
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00FF87)),
            )
          : _partidos.isEmpty
          ? const Center(child: Text("No se encontraron partidos hoy."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _partidos.length,
              itemBuilder: (context, index) {
                // Extraemos los datos de CADA partido individualmente
                var partido = _partidos[index];
                var equipoLocal = partido['teams']['home'];
                var equipoVisita = partido['teams']['away'];
                var goles = partido['goals'];
                var estado =
                    partido['fixture']['status']['short']; // Ej: FT, 1H, NS

                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // EQUIPO LOCAL
                        Expanded(
                          child: Column(
                            children: [
                              Image.network(
                                equipoLocal['logo'],
                                height: 40,
                                errorBuilder: (c, o, s) =>
                                    const Icon(Icons.shield),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                equipoLocal['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),

                        // MARCADOR CENTRAL
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                estado,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${goles['home'] ?? 0} - ${goles['away'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00FF87), // Color Neón
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
                                height: 40,
                                errorBuilder: (c, o, s) =>
                                    const Icon(Icons.shield),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                equipoVisita['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
