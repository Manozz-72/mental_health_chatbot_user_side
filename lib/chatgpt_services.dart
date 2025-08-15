import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String _apiKey = "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";  // Replace with your key
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String prompt, List<Map<String, String>> history) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final messages = [
      ...history,
      {"role": "user", "content": prompt},
    ];

    final body = jsonEncode({
      "model": "gpt-4", // or "gpt-3.5-turbo"
      "messages": messages,
      "temperature": 0.7,
    });

    final response = await http.post(Uri.parse(_apiUrl), headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "Error: ${response.body}";
    }
  }
}
