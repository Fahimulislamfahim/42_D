import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models.dart';
import '../providers.dart';
import '../ai_service.dart';
import '../theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Course course;

  const ChatScreen({Key? key, required this.course}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _aiService = AIService();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    final student = ref.read(studentProvider);
    if (student == null) return;

    final db = ref.read(databaseProvider);
    final messages = await db.getMessages(widget.course.id, student.id);
    ref.read(chatProvider.notifier).setMessages(messages);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final student = ref.read(studentProvider);
    if (student == null) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    ref.read(chatProvider.notifier).addMessage(userMessage);
    final db = ref.read(databaseProvider);
    db.saveMessage(userMessage, widget.course.id, student.id);

    _scrollToBottom();

    setState(() {
      _isLoading = true;
    });

    final responseText = await _aiService.sendMessage(
      teacherPersonaPrompt: widget.course.teacherPersonaPrompt,
      studentName: student.name,
      studentId: student.universityId,
      messageText: text,
    );

    final aiMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString() + "_ai",
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    ref.read(chatProvider.notifier).addMessage(aiMessage);
    db.saveMessage(aiMessage, widget.course.id, student.id);

    setState(() {
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name.toUpperCase()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message.isUser ? AppTheme.neonCyan.withOpacity(0.2) : AppTheme.surfaceGrey,
                      border: Border.all(
                        color: message.isUser ? AppTheme.neonCyan : Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? AppTheme.neonCyan : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppTheme.neonCyan),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
