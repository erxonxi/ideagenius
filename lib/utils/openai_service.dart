// OPENAI Functions to use GPT-3

import 'dart:convert';
import "package:http/http.dart" as http;

Future<String> createTodoesOfThink(String apiKey, String think) async {
  final response = await promptCompletion(apiKey,
      "Response same lenguage of think. Create short and specific todoes. Create todoes for following think: $think");

  return response;
}

Future<String> promptCompletion(String apiKey, String prompt) async {
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 128,
      "temperature": 0
    }),
  );

  if (response.statusCode == 200) {
    final utf8Data = utf8.decode(response.bodyBytes);
    final data = json.decode(utf8Data);
    return data['choices'][0]['text'].trim();
  } else {
    throw Exception('Failed to generate completion');
  }
}
