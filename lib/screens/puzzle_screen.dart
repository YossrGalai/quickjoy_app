import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:io';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  int gridSize = 3;

  List<int?> board = [];
  List<int> pieces = [];

  ui.Image? image;

  int clicks = 0;
  int seconds = 0;
  int points = 1000;

  bool isPaused = false;
  Timer? timer;

  final player = AudioPlayer();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    startGame();
  }

  void startGame() {
    timer?.cancel();

    int total = gridSize * gridSize;

    board = List.filled(total, null);
    pieces = List.generate(total, (i) => i)..shuffle();

    clicks = 0;
    seconds = 0;
    points = 1000;
    isPaused = false;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (!isPaused) {
        setState(() {
          seconds++;
          updateScore();
        });
      }
    });

    setState(() {});
  }

  void updateScore() {
    points = max(0, 1000 - clicks * 5 - seconds * 2);
  }

  bool isSolved() {
    for (int i = 0; i < board.length; i++) {
      if (board[i] != i) return false;
    }
    return true;
  }

  @override
  void dispose() {
    timer?.cancel();
    _confettiController.dispose();
    player.stop();
    super.dispose();
  }

  Widget buildPiece(int index) {
    int row = index ~/ gridSize;
    int col = index % gridSize;

    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        size: const Size(60, 60),
        painter: PuzzlePainter(image!, row, col, gridSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E1E2E),
              Color(0xFF3A0CA3),
              Color(0xFF4361EE),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                Column(
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("⏱ $seconds",
                            style: const TextStyle(color: Colors.white)),
                        Text("🖱 $clicks",
                            style: const TextStyle(color: Colors.white)),
                        Text("⭐ $points",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() => isPaused = !isPaused);
                            },
                            child:
                                Text(isPaused ? "Resume" : "Pause")),
                        ElevatedButton(
                            onPressed: startGame,
                            child: const Text("Replay")),
                        ElevatedButton(
                            onPressed: () {
                              player.stop();
                              Navigator.pop(context);
                            },
                            child: const Text("Quit")),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// GRID
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: GridView.builder(
                            itemCount: board.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridSize,
                            ),
                            itemBuilder: (context, index) {
                              return DragTarget<int>(
                                onAccept: (data) {
                                  if (isPaused) return;

                                  setState(() {
                                    if (data == index) {
                                      board[index] = data;
                                      pieces.remove(data);
                                    }
                                    clicks++;
                                    updateScore();
                                  });

                                  if (isSolved()) {
                                    timer?.cancel();
                                    _confettiController.play();

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("🎉 Bravo !"),
                                        content: Text(
                                            "Puzzle réussi !\nTemps: $seconds\nClics: $clicks\nPoints: $points"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context);
                                              Navigator.pop(
                                                  context);
                                            },
                                            child:
                                                const Text("Accueil"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              player.stop();
                                              exit(0);
                                            },
                                            child:
                                                const Text("Quitter"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                builder: (_, __, ___) => Container(
                                  margin:
                                      const EdgeInsets.all(2),
                                  color: Colors.grey[200],
                                  child: board[index] != null
                                      ? buildPiece(
                                          board[index]!)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    /// PIECES BAR
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pieces.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          int value = pieces[index];

                          return Draggable<int>(
                            data: value,
                            feedback: SizedBox(
                              width: 80,
                              height: 80,
                              child: buildPiece(value),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: buildPiece(value),
                            ),
                            child: Container(
                              margin:
                                  const EdgeInsets.all(4),
                              child: buildPiece(value),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                /// 🎉 CONFETTI
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController:
                        _confettiController,
                    blastDirection: pi / 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final int row, col, gridSize;

  PuzzlePainter(this.image, this.row, this.col, this.gridSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    double w = image.width / gridSize;
    double h = image.height / gridSize;

    Rect src = Rect.fromLTWH(col * w, row * h, w, h);
    Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
