import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateDescription(String title) async {
  final response = await http.post(
    Uri.parse("http://localhost:5678/webhook-test/puzzle-ai"), 
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"title": title}),
  );

  final data = jsonDecode(response.body);
  return data["description"];
}