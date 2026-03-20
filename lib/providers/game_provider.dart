import 'package:flutter/material.dart';

enum GameCategory { quiz, puzzle }

class GameProvider extends ChangeNotifier {
  // Score global du joueur
  int _totalScore = 0;
  int get totalScore => _totalScore;

  // Sessions jouées aujourd'hui
  int _sessionsToday = 0;
  int get sessionsToday => _sessionsToday;

  // Catégorie sélectionnée
  GameCategory? _selectedCategory;
  GameCategory? get selectedCategory => _selectedCategory;

  // Score en cours de session
  int _sessionScore = 0;
  int get sessionScore => _sessionScore;

  // État de la partie
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // Sélectionner une catégorie
  void selectCategory(GameCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Démarrer une session
  void startSession() {
    _isPlaying = true;
    _sessionScore = 0;
    _sessionsToday++;
    notifyListeners();
  }

  // Ajouter des points
  void addPoints(int points) {
    _sessionScore += points;
    _totalScore += points;
    notifyListeners();
  }

  // Terminer la session
  void endSession() {
    _isPlaying = false;
    notifyListeners();
  }

  // Remettre à zéro la session en cours
  void resetSession() {
    _sessionScore = 0;
    _isPlaying = false;
    notifyListeners();
  }
}