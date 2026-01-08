import 'package:http/http.dart' as http;

void main() async {
  print('📞 Llamando directo a la fuente (API-SPORTS)...');

  var url = Uri.parse('https://v3.football.api-sports.io/status');

  var response = await http.get(
    url,
    headers: {
      // ¡AQUÍ ESTÁ LA CORRECCIÓN! Mira las comillas ' ' alrededor de la clave
      'x-apisports-key': '485cacc4493fd838702f7bec01925c8c',
    },
  );

  print('---------------- RESULTADO ----------------');
  print('Estatus: ${response.statusCode}');
  print('Respuesta: ${response.body}');
  print('-------------------------------------------');
}
