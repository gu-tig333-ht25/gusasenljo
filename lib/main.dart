import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Startar appen med MyApp som root-widget
}

// Enkel modell för en Task (uppgift)
class Task {
  String title; // Namn på uppgiften
  bool done;   // Om uppgiften är klar eller inte
  Task(this.title, {this.done = false}); // done är default false
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(), // Sätter HomeScreen som första skärmen
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista med uppgifter, startar med tre objekt
  List<Task> tasks = [
    Task("Äta"),
    Task("Sova"),
    Task("Träna"),
  ];

  // Filter för visning av uppgifter: 'all', 'done', 'notDone'
  String filter = 'all';

  // Returnerar listan med uppgifter baserat på valt filter
  List<Task> get filteredTasks {
    if (filter == 'done') {
      return tasks.where((task) => task.done).toList(); // Endast klara uppgifter
    } else if (filter == 'notDone') {
      return tasks.where((task) => !task.done).toList(); // Endast ogjorda uppgifter
    } else {
      return tasks; // Alla uppgifter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Översta baren med titel och filter-meny
      appBar: AppBar(
        title: const Text(
          "Att göra",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,

        // PopupMenuButton som fungerar som filter-meny
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list, color: Colors.black), // Ikon för menyn
          onSelected: (value) {
            // När ett filter väljs uppdateras skärmen
            setState(() {
              filter = value;
            });
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'all', child: Text('Alla')),
            PopupMenuItem(value: 'done', child: Text('Gjorda')),
            PopupMenuItem(value: 'notDone', child: Text('Ogjorda')),
          ],
        ),
      ),

      // Huvudinnehåll: lista med uppgifter
      body: ListView(
        children: filteredTasks.map((task) {
          return ListTile(
            leading: Checkbox(
              value: task.done, // Visa om uppgiften är klar
              onChanged: (val) {
                setState(() {
                  task.done = val!; // Uppdatera status när checkbox ändras
                });
              },
            ),
            title: Text(
              task.title,
              style: const TextStyle(fontSize: 24, color: Colors.blue), // Textstorlek och färg
            ),
          );
        }).toList(),
      ),

      // Flytande knapp för att lägga till ny uppgift
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigerar till AddItemScreen och väntar på texten som returneras
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );

          // Om något skrivits in, lägg till som ny uppgift
          if (newTask != null && newTask.isNotEmpty) {
            setState(() {
              tasks.add(Task(newTask));
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Skärm för att lägga till en ny uppgift
class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(); // Hanterar textfältet

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lägga till uppgift",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Avstånd runt innehållet
        child: Column(
          children: [
            // Textfält för ny uppgift
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Ny uppgift",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Litet mellanrum
            // Knapp för att lägga till uppgiften
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text); // Skickar tillbaka texten till HomeScreen
              },
              child: const Text("Lägg till"),
            ),
          ],
        ),
      ),
    );
  }
}