import 'dart:convert';
import 'dart:io';

class AiService {
  // 🔥 URL de base (à modifier UNE SEULE FOIS ici)
  static const String baseUrl = "https://alec-nonaquatic-miesha.ngrok-free.dev";

  /// Génère une description à partir du titre
  static Future<String> generateDescription({required String title}) async {
    
    // 🔗 Construction automatique de l'URL
    final uri = Uri.parse("$baseUrl/webhook/puzzle-ai");

    final client = HttpClient();
    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;

    // Envoyer uniquement le titre
    final requestBody = {"title": title};
    request.write(jsonEncode(requestBody));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    client.close();

    // 🔹 debug pour voir la réponse exacte
    // print("AI response: $responseBody");

    try {
      final data = jsonDecode(responseBody);

      // Récupérer la description directement
      if (data is Map<String, dynamic> && data.containsKey("description")) {
        return data["description"] ?? "Aucune description générée";
      }

      return "Aucune description générée";
    } catch (e) {
      return "Erreur lors de la génération de description: $e";
    }
  }
}