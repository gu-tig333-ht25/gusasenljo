import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp()); // <-- Viktigt: matchar klassen nedan
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Att göra",
      theme: ThemeData(
        primarySwatch: Colors.red, // måste vara en MaterialColor
      ),
      home: Homescreen(),
    );
  }
}

// Tillfällig placeholder
class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Att göra")),
      body: Center(child: Text("Här ska listan komma")),
    );
  }
}