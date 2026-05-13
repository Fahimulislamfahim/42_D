class Student {
  final String id;
  final String name;
  final String universityId;
  final String section;

  Student({
    required this.id,
    required this.name,
    required this.universityId,
    required this.section,
  });

  factory Student.fromMap(Map<String, dynamic> data, String documentId) {
    return Student(
      id: documentId,
      name: data['name'] ?? '',
      universityId: data['universityId'] ?? '',
      section: data['section'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'universityId': universityId,
      'section': section,
    };
  }
}

class Course {
  final String id;
  final String name;
  final String teacherPersonaPrompt;

  Course({
    required this.id,
    required this.name,
    required this.teacherPersonaPrompt,
  });

  factory Course.fromMap(Map<String, dynamic> data, String documentId) {
    return Course(
      id: documentId,
      name: data['name'] ?? '',
      teacherPersonaPrompt: data['teacherPersonaPrompt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teacherPersonaPrompt': teacherPersonaPrompt,
    };
  }
}

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    return Message(
      id: documentId,
      text: data['text'] ?? '',
      isUser: data['isUser'] ?? true,
      timestamp: data['timestamp'] != null ? DateTime.parse(data['timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String courseId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
  });

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      courseId: data['courseId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'courseId': courseId,
    };
  }
}
