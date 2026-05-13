import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'database_service.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

final studentProvider = StateProvider<Student?>((ref) => null);

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getCourses();
});

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getTasks();
});

class ChatNotifier extends Notifier<List<Message>> {
  @override
  List<Message> build() => [];

  void setMessages(List<Message> messages) {
    state = messages;
  }

  void addMessage(Message message) {
    state = [...state, message];
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<Message>>(() {
  return ChatNotifier();
});
