import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mock initial data if firebase fails
  static final List<Course> _mockCourses = [
    Course(id: 'c1', name: 'Software Engineering', teacherPersonaPrompt: 'You are an expert Software Engineering Professor.'),
    Course(id: 'c2', name: 'Mathematics', teacherPersonaPrompt: 'You are a strict but fair Math Teacher.'),
    Course(id: 'c3', name: 'Physics', teacherPersonaPrompt: 'You are an enthusiastic Physics Teacher.'),
    Course(id: 'c4', name: 'History', teacherPersonaPrompt: 'You are a wise History Professor.'),
    Course(id: 'c5', name: 'Art', teacherPersonaPrompt: 'You are a creative Art Instructor.'),
    Course(id: 'c6', name: 'Physical Education', teacherPersonaPrompt: 'You are an energetic PE Coach.'),
  ];

  static final List<Task> _mockTasks = [
    Task(id: 't1', title: 'Complete Assignment 1', description: 'Due tomorrow', courseId: 'c1'),
    Task(id: 't2', title: 'Read Chapter 4', description: 'For next week class', courseId: 'c2'),
  ];

  Future<Student?> authenticate(String universityId, String password) async {
    try {
      // In a real app we'd use Firebase Auth and then fetch the user profile.
      // Here we assume a users collection.
      final query = await _db.collection('users')
          .where('universityId', isEqualTo: universityId)
          // Note: Storing plain text passwords is a bad practice.
          // This is just a basic architecture mockup.
          .where('password', isEqualTo: password)
          .get();

      if (query.docs.isNotEmpty) {
        return Student.fromMap(query.docs.first.data(), query.docs.first.id);
      }
      return null;
    } catch (e) {
      print("Firestore authentication failed: $e. Returning mock student.");
      // Fallback for UI exploration if Firebase is not fully configured
      if (universityId.isNotEmpty && password.isNotEmpty) {
        return Student(id: 'user_1', name: 'Test User', universityId: universityId, section: '42_D');
      }
      return null;
    }
  }

  Future<List<Course>> getCourses() async {
    try {
      final snapshot = await _db.collection('courses').get();
      if (snapshot.docs.isEmpty) {
         return _mockCourses;
      }
      return snapshot.docs.map((doc) => Course.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Firestore getCourses failed: $e. Returning mock courses.");
      return _mockCourses;
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final snapshot = await _db.collection('tasks').get();
      if (snapshot.docs.isEmpty) {
         return _mockTasks;
      }
      return snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Firestore getTasks failed: $e. Returning mock tasks.");
      return _mockTasks;
    }
  }

  Future<List<Message>> getMessages(String courseId, String studentId) async {
    try {
      final snapshot = await _db.collection('messages')
          .where('courseId', isEqualTo: courseId)
          .where('studentId', isEqualTo: studentId)
          .orderBy('timestamp', descending: false)
          .get();
      return snapshot.docs.map((doc) => Message.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Firestore getMessages failed: $e. Returning empty list.");
      return [];
    }
  }

  Future<void> saveMessage(Message message, String courseId, String studentId) async {
    try {
      await _db.collection('messages').add({
        ...message.toMap(),
        'courseId': courseId,
        'studentId': studentId,
      });
    } catch (e) {
       print("Firestore saveMessage failed: $e. Skipping save.");
    }
  }
}
