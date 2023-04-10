// OPENAI Functions to use GPT-3

import 'dart:convert';
import "package:http/http.dart" as http;

Future<String> createTodoesOfThink(String apiKey, String think) async {
  return await promptCompletion(
      apiKey, "Crea los passos para lograr la siguiente idea: $think");
}

Future<String> createSummary(String apiKey, String topic) async {
  return await promptCompletion(
      apiKey, "Resumir el siguiente tema en un maximo de 255 palabras: $topic");
}

Future<String> createQuestions(String apiKey, String note) async {
  return await promptCompletion(apiKey,
      "Crear 5 preguntas de repaso basadas en la siguiente nota: $note");
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
      "max_tokens": 255,
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
