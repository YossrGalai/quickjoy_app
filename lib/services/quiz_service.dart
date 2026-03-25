import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuizService {
  //static const _apiUrl = "https://openrouter.ai/api/v1/chat/completions";
  static final _apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
  //static final _apiKey = dotenv.env['ANTHROPIC_API_KEY'] ?? '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';
  Future<String> getExplanation({
    required String question,
    required String correctAnswer,
    required String explanation,
    required bool isCorrect,
  }) async {
    final prompt = isCorrect
        ? 'L\'utilisateur a correctement répondu à cette question de quiz sur la Tunisie:\n'
            'Question: $question\n'
            'Bonne réponse: $correctAnswer\n'
            'Explication de base: $explanation\n\n'
            'Donne une explication courte et engageante (2-3 phrases max) qui enrichit la connaissance, avec un fait intéressant supplémentaire. Sois enthousiaste!'
        : 'L\'utilisateur a mal répondu à cette question de quiz sur la Tunisie:\n'
            'Question: $question\n'
            'Bonne réponse: $correctAnswer\n'
            'Explication de base: $explanation\n\n'
            'Donne une explication pédagogique courte (2-3 phrases max) qui aide à retenir la bonne réponse. Sois encourageant et bienveillant.';

    return _callAI(prompt);
  }

  Future<String> generateSummary({
    required QuizResult result,
    required String levelName,
  }) async {
    final pct = (result.accuracy * 100).round();
    final prompt = 'Génère un bilan personnalisé et motivant pour un joueur qui vient de terminer un quiz sur la Tunisie.\n\n'
        'Stats:\n'
        '- Niveau: $levelName\n'
        '- Score: ${result.score} points\n'
        '- Bonnes réponses: ${result.correct}/${result.total}\n'
        '- Précision: $pct%\n'
        '- Combo maximum: ${result.maxCombo}x\n'
        '- Niveau joueur: ${result.playerLevel}\n\n'
        'Écris un bilan en 3-4 phrases: félicite ou encourage selon les résultats, identifie les points forts, suggère un axe d\'amélioration, et termine par une phrase motivante sur la Tunisie.';

    return _callAI(prompt);
  }

  Future<List<QuizQuestion>> generateQuestions(int count, String difficulty) async {
    final prompt = '''
  Génère $count questions de quiz sur la Tunisie.
  Réponds UNIQUEMENT avec un tableau JSON valide, sans texte avant ou après.
  Sans markdown, sans explication. Juste le JSON pur.

  Format STRICT :
  [
    {
      "category": "...",
      "question": "...",
      "options": ["A", "B", "C", "D"],
      "correctIndex": 0,
      "explanation": "Explication complète en 1-2 phrases qui justifie la bonne réponse.",
      "difficulty": "$difficulty"
    }
  ]

  Contraintes :
  - 4 options exactement
  - correctIndex entre 0 et 3 , pas forcement toujours 0!!
  - explanation OBLIGATOIRE : minimum 10 mots, jamais vide
  - category parmi : HISTOIRE, GÉOGRAPHIE, CULTURE, ÉCONOMIE
  - pas de texte hors JSON
  ''';

    final responseText = await _callAI(prompt);

    try {
      // Nettoyage
      String cleaned = responseText
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      // Extraire uniquement le tableau JSON
      final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(cleaned);
      if (jsonMatch != null) {
        cleaned = jsonMatch.group(0)!;
      }

      final List data = jsonDecode(cleaned);
      return data.map((q) => QuizQuestion.fromJson(q)).toList();

    } on FormatException catch (e) {
      print('JSON invalide: $e');
      print('Réponse brute: $responseText');

      // Récupération partielle : extraire les objets JSON complets
      final matches = RegExp(r'\{[^{}]*\}').allMatches(responseText);
      final validQuestions = <QuizQuestion>[];

      for (final match in matches) {
        try {
          final obj = jsonDecode(match.group(0)!);
          validQuestions.add(QuizQuestion.fromJson(obj));
        } catch (_) {}
      }

      if (validQuestions.isNotEmpty) return validQuestions;
      throw Exception('Impossible de parser les questions IA');
    }
  }

  Future<String> _callAI(String prompt) async {
    print("API KEY: $_apiKey");
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': "meta-llama/llama-3.3-70b-instruct",
        'messages': [{'role': 'user', 'content': prompt},],
        'max_tokens': 4000,
        'temperature': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      String text = data['choices'][0]['message']['content'];

      return text.replaceAll("```json", "").replaceAll("```", "").trim();
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }
}