import 'package:flutter/material.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar( //översta baren 
        title: const Text(
          "Lägga till uppgift", //titeln till den
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),

      //innehållet på sidan
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField( //där man skriver in den nya uppgiften
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Ny uppgift",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () { //knappen som lägger till uppgiten
                Navigator.pop(context, controller.text);
              },
              child: const Text("Lägg till"), //texten på knappen
            ),
          ],
        ),
      ),
    );
  }
}