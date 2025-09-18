import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'home_screen.dart'; // Importerar vår huvudskärm

void main() {
  runApp(const MyApp()); // Startar appen
=======
import 'home_screen.dart';

void main() {
  runApp(const MyApp()); //kör appen
>>>>>>> Stashed changes
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
<<<<<<< Updated upstream
      home: HomeScreen(), // Appen startar på HomeScreen
=======
      home: HomeScreen(), //startar homescreen
>>>>>>> Stashed changes
    );
  }
}