

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:io';

class MosaicPuzzleScreen extends StatefulWidget {
  final String imagePath;
  const MosaicPuzzleScreen({super.key, required this.imagePath});

  @override
  State<MosaicPuzzleScreen> createState() => _MosaicPuzzleScreenState();
}

class _MosaicPuzzleScreenState extends State<MosaicPuzzleScreen> {
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
  late ConfettiController confetti;

  @override
  void initState() {
    super.initState();

    confetti = ConfettiController(duration: const Duration(seconds: 3));

    startMusic();
    loadImage();
  }

  /// 🎶 MUSIC AUTO
  Future<void> startMusic() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('sounds/lahn-mansit.mp3'));
  }

  /// 🖼 LOAD IMAGE
  Future<void> loadImage() async {
    final data = await rootBundle.load(widget.imagePath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    if (!mounted) return;

    setState(() {
      image = frame.image;
    });

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

    // 💀 CONDITION ÉCHEC
    if (points <= 0) {
      timer?.cancel();
      showFailDialog();
    }
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
    confetti.dispose();
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 12),

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("⏱ $seconds",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        Text("🖱 $clicks",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        Text("⭐ $points",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: Text(isPaused ? "Reprendre" : "Pause"),
                        ),
                        ElevatedButton(
                          onPressed: startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text("Rejouer"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            player.stop();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text("Quitter"),
                        ),
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
                                    confetti.play();

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("🎉 Bravo !"),
                                        content: Text(
                                            "Puzzle terminé !\nTemps: $seconds s\nClics: $clicks\nPoints: $points"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Accueil"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              player.stop();
                                              exit(0);
                                            },
                                            child: const Text("Quitter"),
                                          ),
                                        ],
                                      ),
                                      
                                    );
                                  }
                                },
                                builder: (_, __, ___) => Container(
                                  margin: const EdgeInsets.all(2),
                                  color: Colors.grey[300],
                                  child: board[index] != null
                                      ? buildPiece(board[index]!)
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
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: buildPiece(value),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// GRID SIZE CHOIX
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [3, 4, 5, 6].map((size) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  gridSize = size;
                                  startGame();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              child: Text("${size}x$size"),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                /// 🎉 CONFETTI
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: confetti,
                    blastDirection: pi / 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    maxBlastForce: 10,
                    minBlastForce: 5,
                    gravity: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showFailDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E1E2E),
              Color(0xFF3A0CA3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "💀 Échec !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Temps: $seconds s\nClics: $clicks\nPoints: $points",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // 🔁 REPLAY
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    startGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: const Text("Rejouer"),
                ),

                // 🏠 ACCUEIL
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text("Accueil"),
                ),

                // ❌ QUIT
                ElevatedButton(
                  onPressed: () {
                    player.stop();
                    exit(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text("Quiter"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}

/// 🎨 PAINTER
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

/// 🧩 CLIPPER
class PuzzleClipper extends CustomClipper<Path> {
  final int row, col, size;

  PuzzleClipper(this.row, this.col, this.size);

  @override
  Path getClip(Size s) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, s.width, s.height));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
