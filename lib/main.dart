import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/game_provider.dart';
import 'controllers/quiz_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Fullscreen immersive
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await dotenv.load(fileName: ".env");
  print("ENV LOADED: ${dotenv.env}");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => QuizController()),
      ],
      child: const SnapMindApp(),
    ),
  );
}