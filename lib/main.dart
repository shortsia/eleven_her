import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/match_detail_screen.dart'; // <--- IMPORTAMOS TU NUEVA PANTALLA

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

  List<dynamic> _partidos = [];
  bool _cargando = true;
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cargarPartidos();
  }

  void _cargarPartidos() async {
    var nuevosPartidos = await _apiService.getMatches(_fechaSeleccionada);
    setState(() {
      _partidos = nuevosPartidos;
      _cargando = false;
    });
  }

  void _cambiarFecha(DateTime nuevaFecha) {
    setState(() {
      _fechaSeleccionada = nuevaFecha;
      _cargando = true;
      _partidos = [];
    });
    _cargarPartidos();
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- CALENDARIO ---
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                DateTime fechaBoton = DateTime.now().add(
                  Duration(days: index - 1),
                );
                bool esHoy = index == 1;
                bool estaSeleccionado =
                    fechaBoton.day == _fechaSeleccionada.day &&
                    fechaBoton.month == _fechaSeleccionada.month;
                List<String> diasSemana = [
                  'Lun',
                  'Mar',
                  'Mié',
                  'Jue',
                  'Vie',
                  'Sáb',
                  'Dom',
                ];
                String nombreDia = esHoy
                    ? "HOY"
                    : diasSemana[fechaBoton.weekday - 1];

                return GestureDetector(
                  onTap: () => _cambiarFecha(fechaBoton),
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: estaSeleccionado
                          ? const Color(0xFF00FF87)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: estaSeleccionado
                            ? const Color(0xFF00FF87)
                            : Colors.grey.shade800,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nombreDia,
                          style: TextStyle(
                            color: estaSeleccionado
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${fechaBoton.day}",
                          style: TextStyle(
                            color: estaSeleccionado
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- LISTA DE PARTIDOS ---
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00FF87)),
                  )
                : _partidos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Sin partidos VIP esta fecha",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _partidos.length,
                    itemBuilder: (context, index) {
                      var partido = _partidos[index];
                      var equipoLocal = partido['teams']['home'];
                      var equipoVisita = partido['teams']['away'];
                      var goles = partido['goals'];
                      var estado = partido['fixture']['status']['short'];
                      var liga = partido['league'];

                      // GESTURE DETECTOR: Esto hace que la tarjeta sea "Tocable"
                      return GestureDetector(
                        onTap: () {
                          // NAVEGACIÓN: Ir a la pantalla de detalle
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MatchDetailScreen(partido: partido),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFF1E1E1E),
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
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
                                    Expanded(
                                      child: Text(
                                        liga['name'].toString().toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.touch_app,
                                      size: 14,
                                      color: Color(0xFF00FF87),
                                    ), // Icono pequeñito para indicar que se puede tocar
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            equipoLocal['logo'],
                                            height: 45,
                                            errorBuilder: (c, o, s) =>
                                                const Icon(
                                                  Icons.shield,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
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
                                    Column(
                                      children: [
                                        Text(
                                          estado ?? "-",
                                          style: const TextStyle(
                                            color: Color(0xFF00FF87),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          child: Text(
                                            '${goles['home'] ?? 0} - ${goles['away'] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            equipoVisita['logo'],
                                            height: 45,
                                            errorBuilder: (c, o, s) =>
                                                const Icon(
                                                  Icons.shield,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
