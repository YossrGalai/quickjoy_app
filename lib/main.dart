/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
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

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'router/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
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