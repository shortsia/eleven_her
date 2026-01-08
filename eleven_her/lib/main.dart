import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Aquí importamos el archivo que acabas de crear

void main() {
  runApp(const ElevenHerApp());
}

class ElevenHerApp extends StatelessWidget {
  const ElevenHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElevenHer',
      debugShowCheckedModeBanner: false,

      // TEMA OSCURO Y MODERNO
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo Negro Mate
        primaryColor: const Color(0xFF8E44AD), // Morado ElevenHer

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F), // Gris oscuro
          elevation: 0,
        ),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8E44AD),
          secondary: Color(0xFF00E676), // Verde Neón para detalles
        ),
      ),

      home: const HomeScreen(), // Arrancamos con tu pantalla
    );
  }
}
