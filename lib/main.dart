import 'package:flutter/material.dart';
// Importaremos la pantalla de Home cuando la creemos.
// Por ahora dará error en 'HomeScreen' hasta que hagamos el Paso 4.
import 'screens/home_screen.dart';

void main() {
  runApp(const ElevenHerApp());
}

class ElevenHerApp extends StatelessWidget {
  const ElevenHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElevenHer',
      debugShowCheckedModeBanner:
          false, // Quita la etiqueta "Debug" de la esquina
      // TEMA DE LA APP (Look & Feel)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // Modo oscuro por defecto
        primaryColor: const Color(
          0xFF8E44AD,
        ), // Un morado vibrante tipo 'Premier League'
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo casi negro
        // Configuración de la barra superior
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Configuración de colores generales
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8E44AD),
          secondary: Color(0xFF00E676), // Verde neón para detalles (live score)
          surface: Color(0xFF1E1E1E), // Color de las tarjetas
        ),
      ),

      // La primera pantalla que se abre
      home: const HomeScreen(),
    );
  }
}
