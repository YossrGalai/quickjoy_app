import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuizService {
  Future<String> getExplanation({
    required String question,
    required String correctAnswer,
    required String explanation,
    required bool isCorrect,
  }) async {
    final prompt = isCorrect
        ? 'Question quiz Tunisie - bonne réponse.\n'
          'Question: $question | Réponse: $correctAnswer\n'
          'Écris 1 seule phrase courte (max 20 mots) avec un fait surprenant. Pas de félicitations.'
        : 'Question quiz Tunisie - mauvaise réponse.\n'
            'Question: $question | Bonne réponse: $correctAnswer\n'
            'Écris 1 seule phrase courte (max 20 mots) pour retenir la bonne réponse. Pas d\'encouragements.';

    return _callAI(prompt);
  }

  Future<String> generateHint({
    required String question,
    required List<String> options,
  }) async {
    final prompt = 'Question quiz Tunisie : "$question"\n'
        'Options : ${options.join(", ")}\n'
        'Donne UN indice subtil de max 12 mots qui oriente sans révéler la réponse. '
        'Pas de "l\'indice est", pas de ponctuation excessive. Juste l\'indice.';

    return _callAI(prompt);
  }

  Future<String> generateSummary({
    required QuizResult result,
    required String levelName,
  }) async {
    final pct = (result.accuracy * 100).round();
    final prompt = 'Bilan quiz Tunisie en 2 phrases max (40 mots max) :\n'
      'Niveau: $levelName | Score: ${result.score}pts | $pct% réussite | Combo max: ${result.maxCombo}x\n'
      'Sois direct et motivant. Pas de introduction, pas de "bien sûr".';

    return _callAI(prompt);
  }
  String _getDifficultyInstructions(String difficulty) {
      switch (difficulty) {
        case 'facile':
          return 'Questions simples et directes. Ex: capitale, drapeau, plat national, mer bordant la Tunisie,grand public, faits connus, capitales, plats célèbres, monuments iconiques.';
        case 'moyen':
          return 'Questions sur dates historiques, présidents, villes importantes, festivals, économie générale,culture générale approfondie, histoire moderne, personnalités, dates importantes.';
        case 'difficile':
          return 'Questions pointues : traités historiques précis, statistiques économiques, personnalités moins connues, événements rares,expert, détails historiques précis, chiffres exacts, événements rares, anecdotes peu connues.';
        default:
          return '';
      }
    }

  Future<List<QuizQuestion>> generateQuestions(
    int count,
      String difficulty, {
      List<String> excludeQuestions = const [],
    }) async {
      final seed = DateTime.now().millisecondsSinceEpoch;
      final exclusions = excludeQuestions.isNotEmpty
          ? 'Évite absolument ces questions déjà posées :\n${excludeQuestions.map((q) => "- $q").join("\n")}'
          : '';
    
    final prompt = '''
  Tu es un expert en culture tunisienne. Génère $count questions de quiz UNIQUES et VARIÉES sur la Tunisie.
  Niveau de difficulté : $difficulty — ${_getDifficultyInstructions(difficulty)}

  Réponds UNIQUEMENT avec un tableau JSON valide, sans texte avant ou après. JSON pur.

  - Seed de génération : $seed (utilise-le pour varier les questions)

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

  Règles OBLIGATOIRES :
  - 4 options exactement, toutes plausibles (pas de mauvaises réponses évidentes)
  - correctIndex entre 0 et 3, VARIÉ (ne pas toujours mettre 0)
  - explanation : minimum 15 mots, précise, enrichissante, jamais vide
  - category parmi : HISTOIRE, GÉOGRAPHIE, CULTURE, ÉCONOMIE, SPORT, PERSONNALITÉS
  - Couvre des catégories DIFFÉRENTES dans les $count questions
  - Questions spécifiques au niveau $difficulty : ${_getDifficultyInstructions(difficulty)}
  - Pas de texte hors JSON
  $exclusions
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
      debugPrint('Erreur de parsing JSON : $e');
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
  static final String _groqApiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  static final _models = [
    'llama-3.3-70b-versatile',
    'llama-3.1-70b-versatile',
    'gemma2-9b-it',
    'llama3-70b-8192',
  ];

  Future<String> _callWithModel(String model, String prompt) async {
    if (_groqApiKey.isEmpty) throw Exception('Clé GROQ_API_KEY manquante');

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqApiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': [{'role': 'user', 'content': prompt}],
        'max_tokens': 4000,
        'temperature': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      String text = data['choices'][0]['message']['content'];
      return text.replaceAll("```json", "").replaceAll("```", "").trim();
    } else if (response.statusCode == 429) {
      throw Exception('429');
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  Future<String> _callAI(String prompt) async {
    for (final model in _models) {
      for (int retry = 0; retry < 2; retry++) {
        try {
          return await _callWithModel(model, prompt);
        } catch (e) {
          if (e.toString().contains('429')) {
            await Future.delayed(Duration(seconds: (retry + 1) * 3));
            continue;
          }
          //print('Erreur $model: $e');
          break;
        }
      }
      //print('Passage au modèle suivant...');
    }
    throw Exception('Tous les modèles indisponibles');
  }
}