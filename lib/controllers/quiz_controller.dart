import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';

enum QuizState { idle, playing, answered, timeout, finished }

class QuizController extends ChangeNotifier {
  // ─── Level ────────────────────────────────────────────────────────────────
  int _levelIndex = 0;
  int get levelIndex => _levelIndex;
  QuizLevel get currentLevel => kQuizLevels[_levelIndex];

  // ─── Message d'erreur ─────────────────────────────
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void setLevel(int index) {
    _levelIndex = index;
    notifyListeners();
  }

  // ─── Game state ───────────────────────────────────────────────────────────
  QuizState _state = QuizState.idle;
  QuizState get state => _state;

  List<QuizQuestion> _questions = [];
  List<String> _askedQuestions = [];
  int _qIndex = 0;
  QuizQuestion? get currentQuestion => _questions.isNotEmpty ? _questions[_qIndex] : null;
  int get qIndex => _qIndex;
  int get totalQuestions => _questions.length;

  // ─── Score / lives ────────────────────────────────────────────────────────
  int _score = 0;
  int _lives = 3;
  int _combo = 0;
  int _maxCombo = 0;
  int _correctCount = 0;
  int get score => _score;
  int get lives => _lives;
  int get combo => _combo;
  int get maxCombo => _maxCombo;
  int get correctCount => _correctCount;

  // ─── XP / player level ────────────────────────────────────────────────────
  int _xp = 0;
  int _playerLevel = 1;
  int _totalXpEarned = 0;
  int get xp => _xp;
  int get playerLevel => _playerLevel;
  int get totalXpEarned => _totalXpEarned;
  int get xpNeeded => _playerLevel * 100;
  double get xpProgress => (_xp / xpNeeded).clamp(0.0, 1.0);

  // ─── Timer ────────────────────────────────────────────────────────────────
  int _timerValue = 30;
  int get timerValue => _timerValue;
  double get timerProgress =>
      (_timerValue / currentLevel.timePerQuestion).clamp(0.0, 1.0);
  Timer? _timer;

  // ─── Answer ───────────────────────────────────────────────────────────────
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;
  Set<int> _hiddenOptions = {};
  Set<int> get hiddenOptions => _hiddenOptions;

  // ─── Lifelines ────────────────────────────────────────────────────────────
  bool _ll50 = true;
  bool _llSkip = true;
  bool _llHint = true;
  bool get ll50Available => _ll50;
  bool get llSkipAvailable => _llSkip;
  bool get llHintAvailable => _llHint;

  // ─── AI ───────────────────────────────────────────────────────────────────
  final QuizService _quizService = QuizService();
  String _aiText = '';
  bool _aiLoading = false;
  bool _aiVisible = false;
  String get aiText => _aiText;
  bool get aiLoading => _aiLoading;
  bool get aiVisible => _aiVisible;

  // ─── Last XP gained (for pop animation) ──────────────────────────────────
  int _lastXpGained = 0;
  int get lastXpGained => _lastXpGained;

  // ─── Result ───────────────────────────────────────────────────────────────
  QuizResult? _result;
  QuizResult? get result => _result;

  // ─── Start ────────────────────────────────────────────────────────────────
  void startGame() async {
    _state = QuizState.idle;
    notifyListeners();

    try {
      _questions = await _quizService.generateQuestions(
        10,
        currentLevel.difficulty,
        excludeQuestions: _askedQuestions,
      );
      _askedQuestions.addAll(_questions.map((q) => q.question));
    } catch (e) {
        //_questions = List<QuizQuestion>.from(kQuizQuestions)..shuffle(Random());
        //_questions = _questions.take(10).toList();
        _errorMessage = 'Impossible de générer les questions via l\'IA : $e';
        debugPrint(_errorMessage); // pour la console   
    }

    _score = 0;
    _lives = 3;
    _combo = 0;
    _maxCombo = 0;
    _correctCount = 0;
    _xp = 0;
    _playerLevel = 1;
    _totalXpEarned = 0;
    _qIndex = 0;
    _ll50 = true;
    _llSkip = true;
    _llHint = true;
    _result = null;
    _state = QuizState.playing;

    _loadQuestion();
  }
  void _loadQuestion() {
    _selectedIndex = null;
    _hiddenOptions = {};
    _aiText = '';
    _aiVisible = false;
    _aiLoading = false;
    _lastXpGained = 0;
    _startTimer();
    notifyListeners();
  }

  // ─── Timer ────────────────────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timerValue = currentLevel.timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerValue > 0) {
        _timerValue--;
        notifyListeners();
      } else {
        t.cancel();
        _onTimeout();
      }
    });
  }

  void _stopTimer() => _timer?.cancel();

  void _onTimeout() {
    if (currentQuestion == null) return;

    _combo = 0;
    _lives--;
    _state = QuizState.timeout;
    _showAI(currentQuestion!.explanation, false);
    notifyListeners();
    if (_lives <= 0) {
      Future.delayed(const Duration(seconds: 2), endGame);
    }
  }

  // ─── Answer ───────────────────────────────────────────────────────────────
  void selectAnswer(int optionIndex) {
    if (_state != QuizState.playing) return;
    _stopTimer();
    _selectedIndex = optionIndex;
    _state = QuizState.answered;

    final isCorrect = optionIndex == currentQuestion?.correctIndex;

    if (isCorrect) {
      _correctCount++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      final comboBonus = _combo >= 3 ? 1.5 : (_combo >= 2 ? 1.2 : 1.0);
      final timeFactor = 0.5 + 0.5 * (_timerValue / currentLevel.timePerQuestion);
      final gained =
          (100 * currentLevel.scoreMultiplier * comboBonus * timeFactor).round();
      _score += gained;
      _lastXpGained = gained;
      _addXP(gained);
    } else {
      _combo = 0;
      _lives--;
      _lastXpGained = 0;
    }

    _showAI(currentQuestion!.explanation, isCorrect);

    notifyListeners();

    if (_lives <= 0) {
      Future.delayed(const Duration(seconds: 2), endGame);
    }
  }

  void _addXP(int amount) {
    _totalXpEarned += amount;
    _xp += amount;
    while (_xp >= xpNeeded) {
      _xp -= xpNeeded;
      _playerLevel++;
    }
  }

  // ─── Navigation ───────────────────────────────────────────────────────────
  void nextQuestion() {
    if (_qIndex >= _questions.length - 1 || _lives <= 0) {
      endGame();
      return;
    }
    _qIndex++;
    _state = QuizState.playing;
    _loadQuestion();
  }

  void endGame() {
    _stopTimer();
    _state = QuizState.finished;
    _result = QuizResult(
      score: _score,
      correct: _correctCount,
      total: _questions.length,
      maxCombo: _maxCombo,
      xpEarned: _totalXpEarned,
      playerLevel: _playerLevel,
      levelName: currentLevel.name,
      accuracy: _correctCount / _questions.length,
    );
    _generateFinalAI();
    notifyListeners();
  }

  void resetGame() {
    _stopTimer();
    _state = QuizState.idle;
    _result = null;
    _aiText = '';
    _aiVisible = false;
    _askedQuestions = [];
    notifyListeners();
  }

  // ─── Lifelines ────────────────────────────────────────────────────────────
  void useLifeline50() {
    if (!_ll50 || _state != QuizState.playing) return;
    _ll50 = false;
    final correct = currentQuestion?.correctIndex;
    final wrong = List.generate(currentQuestion!.options.length, (i) => i)
        .where((i) => i != correct)
        .toList()
      ..shuffle(Random());
    _hiddenOptions = {wrong[0], wrong[1]};
    notifyListeners();
  }

  void useLifelineSkip() {
    if (!_llSkip || _state != QuizState.playing) return;
    _llSkip = false;
    _stopTimer();
    _state = QuizState.answered;
    _selectedIndex = null;
    _lastXpGained = 0;
    notifyListeners();
  }

  void useLifelineHint() async {
    if (!_llHint || _state != QuizState.playing) return;
    _llHint = false;

    _aiText = '💡 Indice en cours...';
    _aiVisible = true;
    _aiLoading = true;
    notifyListeners();

    try {
      final hint = await _quizService.generateHint(
        question: currentQuestion!.question,
        options: currentQuestion!.options,
      );
      _aiText = '💡 $hint';
    } catch (_) {
      // Fallback : première phrase de l'explication tronquée
      final sentences = currentQuestion!.explanation
          .split('.')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final short = sentences.isNotEmpty ? sentences.first.trim() : currentQuestion!.explanation;
      _aiText = '💡 ${short.length > 60 ? '${short.substring(0, 60)}…' : short}';
    }

    _aiLoading = false;
    notifyListeners();
  }

  // ─── AI ───────────────────────────────────────────────────────────────────
  void _showAI(String fallback, bool isCorrect) async {
    _aiVisible = true;
    _aiLoading = true;
    _aiText = '';
    notifyListeners();
    try {
      final response = await _quizService.getExplanation(
        question: currentQuestion!.question,
        correctAnswer: currentQuestion!.options[currentQuestion!.correctIndex],
        explanation: fallback,
        isCorrect: isCorrect,
      );
      _aiText = response;
    } catch (_) {
      _aiText = fallback;
    }
    _aiLoading = false;
    notifyListeners();
  }

  void _generateFinalAI() async {
    _aiLoading = true;
    _aiText = '';
    _aiVisible = true;
    notifyListeners();
    try {
      final response = await _quizService.generateSummary(
        result: _result!,
        levelName: currentLevel.name,
      );
      _aiText = response;
    } catch (e) {
      debugPrint('generateFinalAI error: $e');
      final pct = (_result!.accuracy * 100).round();
      _aiText = pct >= 80
          ? 'Félicitations! Avec $pct% de réussite en mode ${currentLevel.name}, vous maîtrisez remarquablement la culture tunisienne.'
          : pct >= 50
              ? 'Bonne performance avec $pct% en mode ${currentLevel.name}. Continuez à explorer la richesse de la Tunisie!'
              : 'Avec $pct%, il y a encore du chemin. L\'histoire de Carthage à la révolution de 2011 est fascinante à découvrir!';
    }
    _aiLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}