class Todo {
  int? id;
  String title;
  String description;
  String date; // Ensure this is stored in ISO 8601 format

  Todo({this.id, required this.title, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date, // Ensure this is in ISO 8601 format
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'], // Ensure this is in ISO 8601 format
    );
  }
}