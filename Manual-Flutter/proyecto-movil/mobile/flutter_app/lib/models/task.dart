class Task {
  final int id;
  final String title;
  final bool completed;
  final int? categoryId;
  const Task({required this.id, required this.title, required this.completed, this.categoryId});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int, title: json['title'] as String,
    completed: json['completed'] as bool, categoryId: json['category_id'] as int?,
  );

  Map<String, dynamic> toInput({String? title, bool? completed}) => {
    'title': title ?? this.title, 'completed': completed ?? this.completed, 'category_id': categoryId,
  };
}
