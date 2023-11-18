class Task {
  final int id;
  final String title;
   bool? isCompleted;

  Task({required this.id, required this.title, required this.isCompleted});

  // Convert a Task instance into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
    };
  }

  // Implement a method to create a Task from a Map. The map structure corresponds to the data fetched from the database.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'] == 'TRUE', // or simply map['is_completed'] if it's already a bool
    );
  }

  // Optionally, create a method to copy the Task with modified fields, useful for immutable update patterns.
  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Implement toString to make it easier to see information about each task when using the print statement.
  @override
  String toString() {
    return 'Task{id: $id, title: $title, isCompleted: $isCompleted}';
  }
}
