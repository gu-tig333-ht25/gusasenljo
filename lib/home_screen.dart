
import 'package:flutter/material.dart';
import 'task.dart';
import 'add_item_screen.dart';
import 'api.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista med tasks
  List<Task> tasks = [];

  // Filter: 'all', 'done', 'notDone'
  String filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Hämta tasks från API när appen startar
  }

  /// Hämtar tasks från API och uppdaterar lokalt
  Future<void> _loadTasks() async {
    try {
      final apiTasks = await ApiService.fetchTasks();
      if (!mounted) return; // Säkerställ att widgeten fortfarande finns
      setState(() {
        tasks = apiTasks;
      });
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    }
  }

  /// Returnerar lista baserat på valt filter
  List<Task> get filteredTasks {
    switch (filter) {
      case 'done':
        return tasks.where((t) => t.done).toList();
      case 'notDone':
        return tasks.where((t) => !t.done).toList();
      default:
        return tasks.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar med titel och filter
      appBar: AppBar(
        title: const Text(
          "Att göra",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list, color: Colors.black),
          onSelected: (value) {
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

      // Lista med tasks
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.done,
                onChanged: (val) async {
                  if (val == null) return; // Säkerställ att vi inte får null
                  setState(() {
                    task.done = val;
                  });
                  try {
                    await ApiService.updateTask(task); // Uppdatera server
                  } catch (e) {
                    debugPrint("Error updating task: $e");
                  }
                },
              ),
              title: Text(
                task.title,
                style: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () async {
                  if (task.id == null) return; // Säkerställ giltigt ID
                  try {
                    await ApiService.deleteTask(task.id!); // Ta bort från server
                    setState(() {
                      tasks.remove(task); // Ta bort lokalt
                    });
                  } catch (e) {
                    debugPrint("Error deleting task: $e");
                  }
                },
              ),
            ),
          );
        },
      ),

      // Flytande knapp för att lägga till task
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newTaskTitle = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );

          if (newTaskTitle != null && newTaskTitle.isNotEmpty) {
            final newTask = Task(newTaskTitle, done: false);
            try {
              await ApiService.addTask(newTask);
              _loadTasks();
            } catch (e) {
              debugPrint("Error adding task: $e");
            }
          }
        },
      ),
    );
  }
}
