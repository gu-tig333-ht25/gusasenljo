class Task {
  String? id;       // ID från servern
  String title;  // Uppgiftens titel
  bool done;     // Om uppgiften är klar eller inte

  Task(this.title, {this.done = false, this.id});

  /// Skapar en Task från JSON-data (från API)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'],
      done: json['done'] ?? false,
      id: json['id'],
    );
  }

  /// Konverterar Task till JSON (för att skicka till API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
      if (id != null) 'id': id,
    };
  }
}