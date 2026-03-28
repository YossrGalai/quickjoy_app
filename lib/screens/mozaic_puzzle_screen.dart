import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:io';
import '../services/ai_service.dart';
import '../data/album_data.dart';
import '../providers/game_provider.dart';
import 'package:provider/provider.dart';

class MosaicPuzzleScreen extends StatefulWidget {
  final String imagePath;
  final String? imageName;

  const MosaicPuzzleScreen({super.key, required this.imagePath, this.imageName});

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

  Future<void> startMusic() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource('sounds/lahn-mansit.mp3'));
  }

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
        if (points <= 0) {
          timer?.cancel();
          showFailDialog();
        }
      }
    });
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
            colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("⏱ $seconds", style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text("🖱 $clicks", style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text("⭐ $points", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => isPaused = !isPaused),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                          child: Text(isPaused ? "Reprendre" : "Pause"),
                        ),
                        ElevatedButton(
                          onPressed: startGame,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                          child: const Text("Rejouer"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            player.stop();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text("Quitter"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: GridView.builder(
                            itemCount: board.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridSize),
                            itemBuilder: (context, index) {
                              return DragTarget<int>(
                                onAccept: (data) async {
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
                                    Provider.of<GameProvider>(context, listen: false).addScore(points);
                                    _showSuccessDialog();
                                  }
                                },
                                builder: (_, __, ___) => Container(
                                  margin: const EdgeInsets.all(2),
                                  color: Colors.grey[300],
                                  child: board[index] != null ? buildPiece(board[index]!) : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pieces.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          int value = pieces[index];
                          return Draggable<int>(
                            key: ValueKey(value),
                            data: value,
                            feedback: Material(
                              color: Colors.transparent,
                              child: buildPiece(value),
                            ),
                            childWhenDragging: const SizedBox(width: 60, height: 60),
                            child: Container(margin: const EdgeInsets.all(4), child: buildPiece(value)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [3, 4, 5, 6].map((size) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () => setState(() { gridSize = size; startGame(); }),
                            child: Text("${size}x$size"),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(confettiController: confetti, blastDirection: pi / 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Bravo !"),
        content: Text("Puzzle réussi !\n\n⏱ Temps: $seconds s\n🖱 Clics: $clicks\n⭐ Points: $points\n\nVoulez-vous l'ajouter à votre album ?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Fermer Bravo

              if (AlbumData.exists(widget.imagePath)) {
                _showAlreadyExistsDialog();
                return;
              }

              // Génération et ajout
              final desc = await AiService.generateDescription(title: widget.imageName ?? "Puzzle");
              AlbumData.addItem(
                imagePath: widget.imagePath,
                title: widget.imageName ?? "Puzzle",
                description: desc,
              );

              // Retourner à SelectImageScreen en signalant un changement
              if (mounted) {
                Navigator.pop(context, true); 
              }
            },
            child: const Text("Oui"),
          ),
          TextButton(
            onPressed: () => { Navigator.pop(context), Navigator.pop(context) },
            child: const Text("Non"),
          ),
        ],
      ),
    );
  }

  void _showAlreadyExistsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("⚠️"),
        content: const Text("Déjà existant dans l'album"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer erreur
              Navigator.pop(context); // Quitter puzzle
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void showFailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("💀 Échec !", style: TextStyle(color: Colors.white)),
        content: Text("Temps écoulé ou points épuisés.", style: const TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(onPressed: () { Navigator.pop(context); startGame(); }, child: const Text("Rejouer")),
          ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text("Accueil")),
        ],
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