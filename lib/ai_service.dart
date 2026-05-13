import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static const String _baseUrl = 'https://integrate.api.nvidia.com/v1/chat/completions';

  Future<String> sendMessage({
    required String teacherPersonaPrompt,
    required String studentName,
    required String studentId,
    required String messageText,
  }) async {
    final apiKey = dotenv.env['NVIDIA_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return "Error: NVIDIA API Key is not set in .env";
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final systemInstruction = '''
$teacherPersonaPrompt
You are talking to a student.
Student Name: $studentName
Student ID: $studentId
Section: 42_D
Address the student by their name and ID.
''';

    final body = jsonEncode({
      "model": "meta/llama-3.1-405b-instruct", // Default fallback model
      "messages": [
        {
          "role": "system",
          "content": systemInstruction,
        },
        {
          "role": "user",
          "content": messageText,
        }
      ],
      "temperature": 0.5,
      "top_p": 1,
      "max_tokens": 1024,
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? "No response.";
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: Failed to connect to AI Service. $e";
    }
  }
}
