import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StandingsScreen extends StatefulWidget {
  final int leagueId;
  final int season;
  final String leagueName;

  const StandingsScreen({
    super.key,
    required this.leagueId,
    required this.season,
    required this.leagueName,
  });

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _tabla = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarTabla();
  }

  void _cargarTabla() async {
    var nuevaTabla = await _apiService.getStandings(
      widget.leagueId,
      widget.season,
    );
    if (mounted) {
      setState(() {
        _tabla = nuevaTabla;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Tabla - ${widget.leagueName}',
          style: const TextStyle(color: Color(0xFF00FF87), fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00FF87)),
            )
          : _tabla.isEmpty
          ? const Center(
              child: Text(
                "No hay tabla disponible",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // CABECERA DE LA TABLA
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  color: Colors.black26,
                  child: const Row(
                    children: [
                      Text(
                        '#',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Equipo',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 30,
                        child: Text(
                          'PJ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          'PTS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // LISTA DE POSICIONES
                Expanded(
                  child: ListView.builder(
                    itemCount: _tabla.length,
                    itemBuilder: (context, index) {
                      var equipo = _tabla[index];
                      var rank = equipo['rank'];
                      var infoEquipo = equipo['team'];
                      var puntos = equipo['points'];
                      var jugados = equipo['all']['played'];

                      // Colores para zonas (Champions, Descenso)
                      Color colorPosicion = Colors.white;
                      if (index < 4) {
                        colorPosicion = const Color(
                          0xFF00FF87,
                        ); // Champions (Verde)
                      }
                      if (index >= _tabla.length - 3) {
                        colorPosicion = Colors.redAccent; // Descenso (Rojo)
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Posición
                            SizedBox(
                              width: 20,
                              child: Text(
                                '$rank',
                                style: TextStyle(
                                  color: colorPosicion,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Escudo
                            Image.network(
                              infoEquipo['logo'],
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 10),

                            // Nombre
                            Expanded(
                              child: Text(
                                infoEquipo['name'],
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Partidos Jugados
                            SizedBox(
                              width: 30,
                              child: Text(
                                '$jugados',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),

                            // Puntos (Destacado)
                            SizedBox(
                              width: 30,
                              child: Text(
                                '$puntos',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
