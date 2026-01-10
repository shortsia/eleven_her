import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importamos el cerebro
import 'services/api_service.dart';
import 'screens/match_detail_screen.dart';

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
  String _filtroLiga = 'Todos';

  // LISTA DE EQUIPOS FAVORITOS (Ids guardados como texto)
  List<String> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritos(); // Cargar memoria al iniciar
    _cargarPartidos();
  }

  // --- FUNCIONES DE MEMORIA ---
  Future<void> _cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritos = prefs.getStringList('mis_equipos') ?? [];
    });
  }

  Future<void> _toggleFavorito(int equipoId) async {
    final prefs = await SharedPreferences.getInstance();
    String idString = equipoId.toString();

    setState(() {
      if (_favoritos.contains(idString)) {
        _favoritos.remove(idString); // Si ya estaba, lo borramos
      } else {
        _favoritos.add(idString); // Si no estaba, lo guardamos
      }
    });

    // Guardar en el disco del celular
    await prefs.setStringList('mis_equipos', _favoritos);
  }

  bool _esFavorito(int equipoId) {
    return _favoritos.contains(equipoId.toString());
  }
  // ---------------------------

  Future<void> _cargarPartidos() async {
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
      _filtroLiga = 'Todos';
    });
    _cargarPartidos();
  }

  @override
  Widget build(BuildContext context) {
    var partidosAVisualizar = _partidos.where((p) {
      if (_filtroLiga == 'Todos') return true;
      return p['league']['name'] == _filtroLiga;
    }).toList();

    // ORDENAR: Favoritos primero
    partidosAVisualizar.sort((a, b) {
      int idLocalA = a['teams']['home']['id'];
      int idVisitaA = a['teams']['away']['id'];
      bool aEsFav = _esFavorito(idLocalA) || _esFavorito(idVisitaA);

      int idLocalB = b['teams']['home']['id'];
      int idVisitaB = b['teams']['away']['id'];
      bool bEsFav = _esFavorito(idLocalB) || _esFavorito(idVisitaB);

      if (aEsFav && !bEsFav) return -1; // A va primero
      if (!aEsFav && bEsFav) return 1; // B va primero
      return 0; // Iguales
    });

    Set<String> ligasDisponibles = {'Todos'};
    for (var p in _partidos) {
      ligasDisponibles.add(p['league']['name']);
    }

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
          // CALENDARIO
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 5),
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
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: estaSeleccionado
                          ? const Color(0xFF00FF87)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
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
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          "${fechaBoton.day}",
                          style: TextStyle(
                            color: estaSeleccionado
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // FILTROS
          if (!_cargando && _partidos.isNotEmpty)
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: ligasDisponibles.map((nombreLiga) {
                  bool activo = _filtroLiga == nombreLiga;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(nombreLiga),
                      selected: activo,
                      onSelected: (bool selected) {
                        setState(() {
                          _filtroLiga = nombreLiga;
                        });
                      },
                      backgroundColor: const Color(0xFF1E1E1E),
                      selectedColor: const Color(0xFF00FF87).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: activo ? const Color(0xFF00FF87) : Colors.white,
                      ),
                      checkmarkColor: const Color(0xFF00FF87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: activo
                              ? const Color(0xFF00FF87)
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // LISTA
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00FF87)),
                  )
                : partidosAVisualizar.isEmpty
                ? Center(
                    child: Text(
                      "No hay partidos",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                : RefreshIndicator(
                    color: const Color(0xFF121212),
                    backgroundColor: const Color(0xFF00FF87),
                    onRefresh: _cargarPartidos,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: partidosAVisualizar.length,
                      itemBuilder: (context, index) {
                        var partido = partidosAVisualizar[index];
                        var equipoLocal = partido['teams']['home'];
                        var equipoVisita = partido['teams']['away'];
                        var goles = partido['goals'];
                        var estado = partido['fixture']['status']['short'];
                        var minuto = partido['fixture']['status']['elapsed'];
                        var liga = partido['league'];

                        // Verificar Favoritos
                        bool esFavLocal = _esFavorito(equipoLocal['id']);
                        bool esFavVisita = _esFavorito(equipoVisita['id']);
                        bool hayFavorito = esFavLocal || esFavVisita;

                        bool esEnVivo = [
                          '1H',
                          'HT',
                          '2H',
                          'ET',
                          'P',
                          'BT',
                        ].contains(estado);
                        bool termino = ['FT', 'AET', 'PEN'].contains(estado);

                        Widget widgetEstado;
                        if (esEnVivo) {
                          widgetEstado = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.redAccent),
                            ),
                            child: Text(
                              "LIVE $minuto'",
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          );
                        } else if (termino) {
                          widgetEstado = const Text(
                            "FINAL",
                            style: TextStyle(
                              color: Color(0xFF00FF87),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        } else {
                          String hora = partido['fixture']['date']
                              .toString()
                              .substring(11, 16);
                          widgetEstado = Text(
                            hora,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MatchDetailScreen(partido: partido),
                              ),
                            );
                          },
                          child: Card(
                            // Si es favorito, pintamos el borde de dorado suave
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: hayFavorito
                                  ? const BorderSide(
                                      color: Colors.amber,
                                      width: 1,
                                    )
                                  : BorderSide.none,
                            ),
                            color: hayFavorito
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFF1E1E1E),
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: const BorderRadius.vertical(
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
                                      if (hayFavorito)
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.amber,
                                        ), // Estrella en la barra si hay favorito
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // LOCAL
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Image.network(
                                              equipoLocal['logo'],
                                              height: 40,
                                              errorBuilder: (c, o, s) =>
                                                  const Icon(
                                                    Icons.shield,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    equipoLocal['name'],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => _toggleFavorito(
                                                    equipoLocal['id'],
                                                  ),
                                                  child: Icon(
                                                    esFavLocal
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: 18,
                                                    color: esFavLocal
                                                        ? Colors.amber
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        children: [
                                          widgetEstado,
                                          const SizedBox(height: 5),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8),
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

                                      // VISITA
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Image.network(
                                              equipoVisita['logo'],
                                              height: 40,
                                              errorBuilder: (c, o, s) =>
                                                  const Icon(
                                                    Icons.shield,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _toggleFavorito(
                                                    equipoVisita['id'],
                                                  ),
                                                  child: Icon(
                                                    esFavVisita
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: 18,
                                                    color: esFavVisita
                                                        ? Colors.amber
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    equipoVisita['name'],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
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
          ),
        ],
      ),
    );
  }
}
