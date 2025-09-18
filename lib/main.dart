import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importerar vår huvudskärm

void main() {
  runApp(const MyApp()); // Startar appen
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(), // Appen startar på HomeScreen
    );
  }
}