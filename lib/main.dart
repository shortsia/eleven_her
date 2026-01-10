import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // --- VARIABLES NUEVAS ---
  bool _soloFavoritos = false; // El interruptor del filtro
  List<String> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
    _cargarPartidos();
  }

  // --- MEMORIA Y FAVORITOS ---
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
        _favoritos.remove(idString);
      } else {
        _favoritos.add(idString);
      }
    });
    await prefs.setStringList('mis_equipos', _favoritos);
  }

  bool _esFavorito(int equipoId) {
    return _favoritos.contains(equipoId.toString());
  }

  // --- CARGA DE DATOS ---
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
      // Si cambiamos de fecha, desactivamos el filtro de favoritos para ver qué hay
      _soloFavoritos = false;
    });
    _cargarPartidos();
  }

  // --- EL MENÚ LATERAL (DRAWER) ---
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                  "https://media.istockphoto.com/id/1183568858/es/vector/patr%C3%B3n-de-f%C3%BAtbol-con-balones-de-f%C3%BAtbol-deportes-de-f%C3%BAtbol-fondo-verde.jpg?s=612x612&w=0&k=20&c=Xp2N3W_5jXUuQGH0qQKy-9F6V_C7O-2NqYk_1fKk-2k=",
                ),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
            accountName: const Text(
              "ElevenHer",
              style: TextStyle(
                color: Color(0xFF00FF87),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: const Text(
              "Tu App de Fútbol Favorita",
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color(0xFF00FF87),
              child: const Icon(
                Icons.sports_soccer,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF00FF87)),
            title: const Text(
              'Inicio (Todos)',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                _soloFavoritos = false; // Apagar filtro
                _filtroLiga = 'Todos';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text(
              'Mis Favoritos',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                _soloFavoritos = true; // Encender filtro
              });
              Navigator.pop(context);
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text(
              'Acerca de',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: "ElevenHer",
                applicationVersion: "1.3.0",
                applicationIcon: const Icon(
                  Icons.sports_soccer,
                  size: 40,
                  color: Color(0xFF00FF87),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- LÓGICA DE FILTRADO ---
    var partidosAVisualizar = _partidos.where((p) {
      // 1. Filtro de Favoritos
      if (_soloFavoritos) {
        bool localEsFav = _esFavorito(p['teams']['home']['id']);
        bool visitaEsFav = _esFavorito(p['teams']['away']['id']);
        if (!localEsFav && !visitaEsFav) return false;
      }
      // 2. Filtro de Liga
      if (_filtroLiga == 'Todos') return true;
      return p['league']['name'] == _filtroLiga;
    }).toList();

    // Ordenar: Favoritos primero
    partidosAVisualizar.sort((a, b) {
      int idLocalA = a['teams']['home']['id'];
      int idVisitaA = a['teams']['away']['id'];
      bool aEsFav = _esFavorito(idLocalA) || _esFavorito(idVisitaA);

      int idLocalB = b['teams']['home']['id'];
      int idVisitaB = b['teams']['away']['id'];
      bool bEsFav = _esFavorito(idLocalB) || _esFavorito(idVisitaB);

      if (aEsFav && !bEsFav) return -1;
      if (!aEsFav && bEsFav) return 1;
      return 0;
    });

    Set<String> ligasDisponibles = {'Todos'};
    for (var p in _partidos) {
      ligasDisponibles.add(p['league']['name']);
    }

    return Scaffold(
      drawer: _buildDrawer(), // AQUÍ ESTÁ EL MENÚ CONECTADO
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // TÍTULO DINÁMICO
        title: Text(
          _soloFavoritos ? 'Mis Favoritos ⭐' : 'ElevenHer ⚽',
          style: const TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF00FF87),
        ), // Color del icono hamburguesa
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

          // FILTROS (Solo se muestran si NO estamos en modo Favoritos)
          if (!_cargando && _partidos.isNotEmpty && !_soloFavoritos)
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

          // LISTA DE PARTIDOS
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00FF87)),
                  )
                : partidosAVisualizar.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _soloFavoritos
                              ? Icons.star_border
                              : Icons.sports_soccer,
                          size: 50,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _soloFavoritos
                              ? "No juegan tus favoritos hoy"
                              : "No hay partidos",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
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
                                        ),
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
