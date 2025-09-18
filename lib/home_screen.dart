
import 'package:flutter/material.dart';
import 'task.dart';
import 'add_item_screen.dart';


//statefullwidget för att kunna ändra saker i listan
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista med aktiva tasks
  List<Task> tasks = [
    Task("Äta"),
    Task("Sova"),
    Task("Träna"),
  ];

  // Lista med borttagna tasks
  List<Task> removedTasks = [];

  // Filter för visning av uppgifter, standrad är all
  // Kan vara: 'all', 'done', 'notDone', 'removed'
  String filter = 'all';

  // Returnerar listan med tasks baserat på valt filter
  List<Task> get filteredTasks {
    if (filter == 'done') {
      // Endast de som är markerade som klara
      return tasks.where((task) => task.done).toList();
    } else if (filter == 'notDone') {
       // Endast de som INTE är klara
      return tasks.where((task) => !task.done).toList();
    } else if (filter == 'removed') {
       // De som har tagits bort
      return removedTasks;
    } else {
      return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //översta baren
      appBar: AppBar(
        title: const Text(
          "Att göra", //titeln på översta baren
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,

        //menyn till vänster man som man kan välja 'status' i
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list, color: Colors.black),
          onSelected: (value) {
            setState(() {
              filter = value;
            });
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'all', child: Text('Alla')), //visa allt, raderna under förklarar sig själva
            PopupMenuItem(value: 'done', child: Text('Gjorda')),
            PopupMenuItem(value: 'notDone', child: Text('Ogjorda')),
            PopupMenuItem(value: 'removed', child: Text('Borttagna')),
          ],
        ),
      ),

      //'huvud' funktionen eller vad man kallar det som visar listan i homescreen
      body: ListView(
        children: filteredTasks.map((task) {
          return Card( //skapar en ram runt varje uppgift för att enklare särskilja 
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),

            child: ListTile( //skapar kryssrutan till vänster där man kan klarmarkera 'ändra statusen'
              leading: Checkbox(
                value: task.done,
                onChanged: (val) {
                  setState(() {
                    task.done = val!; //statusen
                  });
                },
              ),
              title: Text( //uppgiftens namn
                task.title,
                style: const TextStyle(fontSize: 24, color: Colors.blue),
              ),

              trailing: IconButton( //krysset till höger om alla task/uppgifter
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    tasks.remove(task); // Ta bort från aktiva listan
                    removedTasks.add(task); // Lägg till i "borttagna"
                  });
                },
              ),
            ),
          );
        }).toList(), //gör varje uppgift till listobjekt
      ),


      floatingActionButton: FloatingActionButton( //knapp för att lägga till nya task
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()), //tar en till lägga till skärmen
          );
          if (newTask != null && newTask.isNotEmpty) { //om något skriver lägger till det
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