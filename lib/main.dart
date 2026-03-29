import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'data/album_data.dart';
import 'providers/game_provider.dart';
import 'controllers/quiz_controller.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger le fichier .env
  await dotenv.load(fileName: ".env");
  print("ENV LOADED: ${dotenv.env}");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider.value(value: AlbumData()),
        ChangeNotifierProvider(create: (_) => QuizController()),
      ],
      child: const QuickJoyApp(),
    ),
  );
}

class QuickJoyApp extends StatelessWidget {
  const QuickJoyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickJoy',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}