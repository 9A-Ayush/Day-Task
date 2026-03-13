class SubTask {
  final String name;
  final bool isCompleted;

  SubTask({
    required this.name,
    required this.isCompleted,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      name: json['name'],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_completed': isCompleted,
    };
  }

  SubTask copyWith({
    String? name,
    bool? isCompleted,
  }) {
    return SubTask(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskModel {
  final String? id;
  final String title;
  final String details;
  final List<String> teamMembers;
  final DateTime dateTime;
  final String userId;
  final List<SubTask> subTasks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    this.id,
    required this.title,
    required this.details,
    required this.teamMembers,
    required this.dateTime,
    required this.userId,
    this.subTasks = const [],
    this.createdAt,
    this.updatedAt,
  });

  int get completedSubTasksCount => subTasks.where((task) => task.isCompleted).length;
  
  double get progressPercentage {
    if (subTasks.isEmpty) return 0;
    return (completedSubTasksCount / subTasks.length) * 100;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    List<SubTask> subTasksList = [];
    if (json['sub_tasks'] != null) {
      subTasksList = (json['sub_tasks'] as List)
          .map((task) => SubTask.fromJson(task))
          .toList();
    }

    return TaskModel(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      teamMembers: List<String>.from(json['team_members'] ?? []),
      dateTime: DateTime.parse(json['date_time']),
      userId: json['user_id'],
      subTasks: subTasksList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'team_members': teamMembers,
      'date_time': dateTime.toIso8601String(),
      'user_id': userId,
      'sub_tasks': subTasks.map((task) => task.toJson()).toList(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? details,
    List<String>? teamMembers,
    DateTime? dateTime,
    String? userId,
    List<SubTask>? subTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      teamMembers: teamMembers ?? this.teamMembers,
      dateTime: dateTime ?? this.dateTime,
      userId: userId ?? this.userId,
      subTasks: subTasks ?? this.subTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
