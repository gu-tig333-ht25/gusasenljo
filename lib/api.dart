import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task.dart';

class ApiService {
  static const String baseUrl = 'https://todoapp-api.apps.k8s.gu.se';
  static const String apiKey = '3a7ef191-e6c5-481e-a23b-991721bcbdbc';

  /// Hämtar alla todos från API:t
  static Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('$baseUrl/todos?key=$apiKey');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching tasks: ${response.body}');
    }
  }

  /// Lägger till en ny todo
  static Future<List<Task>> addTask(Task task) async {
    final url = Uri.parse('$baseUrl/todos?key=$apiKey');

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson())); // konvertera Task till JSON

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error adding task: ${response.body}');
    }
  }

  /// Uppdaterar en todo (title eller done)
  static Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/todos/${task.id}?key=$apiKey');

    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Error updating task: ${response.body}');
    }
  }

  /// Tar bort en todo
  static Future<void> deleteTask(String id) async {
    final url = Uri.parse('$baseUrl/todos/$id?key=$apiKey');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error deleting task: ${response.body}');
    }
  }
}