import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AlbumItem {
  final String imagePath;
  final String title;
   String description;

  AlbumItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class AlbumData extends ChangeNotifier {
  static final AlbumData _instance = AlbumData._internal();
  factory AlbumData() => _instance;
  AlbumData._internal();

  static List<AlbumItem> items = [];
  static Set<String> _paths = {};

  /// ✅ Ajout synchronisé si on a déjà description
  static void addItem({
    required String imagePath,
    required String title,
    String description = "",
  }) {
    if (!exists(imagePath)) {
      items.add(AlbumItem(
        imagePath: imagePath,
        title: title,
        description: description,
      ));
      _paths.add(imagePath);
      _instance.notifyListeners();
    }
  }

  /// ✅ Ajout ASYNC avec génération de description via AI
  static Future<void> addItemWithAI({
  required String imagePath,
  required String title,
}) async {
  if (!exists(imagePath)) {
    String description = await AiService.generateDescription(title: title);
    items.add(AlbumItem(
      imagePath: imagePath,
      title: title,
      description: description,
    ));
    _instance.notifyListeners(); // ⚡ Notifier l’UI
  }
}

  /// ✅ Vérifier si l'image existe
  static bool exists(String path) {
    return _paths.contains(path);
  }

  /// ✅ Supprimer par path
  static void removeByPath(String path) {
    items.removeWhere((item) => item.imagePath == path);
    _paths.remove(path);
    _instance.notifyListeners();
  }

  /// ✅ Supprimer par index
  static void removeAt(int index) {
    if (index >= 0 && index < items.length) {
      String path = items[index].imagePath;
      items.removeAt(index);
      _paths.remove(path);
      _instance.notifyListeners();
    }
  }


static Future<void> updateDescription(int index, String description) async {
  if (index >= 0 && index < items.length) {
    items[index].description = description;
    
}
}

static void updateDescriptionByPath(String path, String description) {
  try {
    final item = items.firstWhere((item) => item.imagePath == path);
    item.description = description;
    _instance.notifyListeners();
  } catch (_) {}
}


}