 import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart'; // <-- import

import '../data/album_data.dart';


import '../services/ai_service.dart';



class AlbumScreen extends StatefulWidget {

  const AlbumScreen({super.key});



  @override

  State<AlbumScreen> createState() => _AlbumScreenState();

}



class _AlbumScreenState extends State<AlbumScreen> {

  final PageController _controller = PageController(viewportFraction: 0.9);

  int currentPage = 0;

  bool isLoading = false;

  Map<int, bool> generatingDescriptions = {};



  // 🎵 Audio player

  late AudioPlayer _audioPlayer;



  @override

  void initState() {

    super.initState();

    _audioPlayer = AudioPlayer();



    // Lecture automatique de la musique à l'ouverture

    _playMusic();

  }



  Future<void> _playMusic() async {

    // Assure-toi que "mansit.mp3" est dans le dossier assets et déclaré dans pubspec.yaml

    await _audioPlayer.play(AssetSource('sounds/mansit.mp3'));

  }



  @override

  void dispose() {

    _audioPlayer.stop(); // Arrêter la musique quand on quitte l'écran

    _audioPlayer.dispose();

    _controller.dispose();

    super.dispose();

  }



  void showZoomImage(String path) {

    showDialog(

      context: context,

      builder: (_) => Dialog(

        backgroundColor: Colors.black,

        insetPadding: const EdgeInsets.all(10),

        child: GestureDetector(

          onTap: () => Navigator.pop(context),

          child: InteractiveViewer(

            child: Image.asset(path, fit: BoxFit.contain),

          ),

        ),

      ),

    );

  }



  Future<void> generateDescriptionForItem(int index) async {

    setState(() {

      generatingDescriptions[index] = true;

    });



    try {

      final item = AlbumData.items[index];

      final description = await AiService.generateDescription(title: item.title);

      await AlbumData.updateDescription(index, description);



      setState(() {

        generatingDescriptions[index] = false;

      });



      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(content: Text('Description générée avec succès!')),

        );

      }

    } catch (e) {

      setState(() {

        generatingDescriptions[index] = false;

      });

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text('Erreur: ${e.toString()}')),

        );

      }

    }

  }



  Future<void> addImage(String imagePath, String title) async {

    setState(() => isLoading = true);

    await AlbumData.addItemWithAI(imagePath: imagePath, title: title);

    setState(() => isLoading = false);

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],

          ),

        ),

        child: SafeArea(

          child: Column(

            children: [

              Align(

                alignment: Alignment.topLeft,

                child: IconButton(

                  icon: const Icon(Icons.arrow_back, color: Colors.white),

                  onPressed: () => Navigator.pop(context),

                ),

              ),

              const Text(

                "📖 Mon Album",

                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),

              ),

              const SizedBox(height: 10),

              if (isLoading)

                const Expanded(

                  child: Center(

                    child: CircularProgressIndicator(color: Colors.white),

                  ),

                )

              else if (AlbumData.items.isEmpty)

                const Expanded(

                  child: Center(

                    child: Text("Aucun élément dans l'album ⭐", style: TextStyle(color: Colors.white)),

                  ),

                )

              else

                Expanded(

                  child: Column(

                    children: [

                      Expanded(

                        child: PageView.builder(

                          controller: _controller,

                          itemCount: AlbumData.items.length,

                          onPageChanged: (i) => setState(() => currentPage = i),

                          itemBuilder: (context, index) {

                            final item = AlbumData.items[index];

                            final isGenerating = generatingDescriptions[index] == true;



                            if (item.description.isEmpty && !generatingDescriptions.containsKey(index)) {

                              generateDescriptionForItem(index);

                            }



                            return AnimatedBuilder(

                              animation: _controller,

                              builder: (context, child) {

                                double value = 1;

                                if (_controller.position.haveDimensions && _controller.page != null) {

                                  value = (_controller.page! - index).abs();

                                  value = (1 - value * 0.2).clamp(0.8, 1);

                                }

                                return Center(child: Transform.scale(scale: value, child: child));

                              },

                              child: Padding(

                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),

                                child: Container(

                                  decoration: BoxDecoration(

                                    color: Colors.white,

                                    borderRadius: BorderRadius.circular(20),

                                    boxShadow: [

                                      BoxShadow(color: Colors.black.withAlpha(76), blurRadius: 10, offset: const Offset(0, 5)),

                                    ],

                                  ),

                                  child: Column(

                                    children: [

                                      GestureDetector(

                                        onTap: () => showZoomImage(item.imagePath),

                                        child: Container(

                                          height: 320,

                                          width: double.infinity,

                                          padding: const EdgeInsets.all(10),

                                          child: ClipRRect(

                                            borderRadius: BorderRadius.circular(16),

                                            child: Image.asset(item.imagePath, fit: BoxFit.contain),

                                          ),

                                        ),

                                      ),

                                      Text(

                                        item.title,

                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),

                                        textAlign: TextAlign.center,

                                      ),

                                      const SizedBox(height: 8),

                                      Padding(

                                        padding: const EdgeInsets.symmetric(horizontal: 12),

                                        child: Column(

                                          children: [

                                            if (isGenerating || item.description.isEmpty)

                                              const Padding(

                                                padding: EdgeInsets.all(12.0),

                                                child: Column(

                                                  children: [

                                                    CircularProgressIndicator(),

                                                    SizedBox(height: 8),

                                                    Text(

                                                      "Génération de la description...",

                                                      textAlign: TextAlign.center,

                                                    ),

                                                  ],

                                                ),

                                              )

                                            else

                                              Text(

                                                item.description,

                                                textAlign: TextAlign.center,

                                                style: const TextStyle(fontSize: 14),

                                              ),

                                            const SizedBox(height: 8),

                                            TextButton.icon(

                                              onPressed: isGenerating ? null : () => generateDescriptionForItem(index),

                                              icon: isGenerating

                                                  ? const SizedBox(

                                                      width: 16,

                                                      height: 16,

                                                      child: CircularProgressIndicator(strokeWidth: 2),

                                                    )

                                                  : const Icon(Icons.auto_awesome, size: 16),

                                              label: Text(

                                                isGenerating

                                                    ? "Génération..."

                                                    : (item.description.isNotEmpty ? "Regénérer la description" : "Générer une description"),

                                                style: const TextStyle(fontSize: 12),

                                              ),

                                              style: TextButton.styleFrom(

                                                foregroundColor: const Color(0xFF4361EE),

                                              ),

                                            ),

                                          ],

                                        ),

                                      ),

                                      const SizedBox(height: 10),

                                      ElevatedButton.icon(

                                        onPressed: () {

                                            setState(() {
  AlbumData.removeAt(index);

  final newIndex = index > 0 ? index - 1 : 0;

  if (AlbumData.items.isEmpty) {
    currentPage = 0;
  } else {
    currentPage = newIndex.clamp(0, AlbumData.items.length - 1);
  }
});


                                            if (AlbumData.items.isNotEmpty) {

                                              _controller.jumpToPage(currentPage);

                                            }

                                          },

                                        icon: const Icon(Icons.delete),

                                        label: const Text("Retirer de l'album"),

                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),

                                      ),

                                      const SizedBox(height: 10),

                                    ],

                                  ),

                                ),

                              ),

                            );

                          },

                        ),

                      ),

                      Row(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: List.generate(

                          AlbumData.items.length,

                          (index) => AnimatedContainer(

                            duration: const Duration(milliseconds: 300),

                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),

                            width: currentPage == index ? 12 : 8,

                            height: currentPage == index ? 12 : 8,

                            decoration: BoxDecoration(

                              color: currentPage == index ? Colors.white : Colors.white54,

                              shape: BoxShape.circle,

                            ),

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

            ],

          ),

        ),

      ),

    );

  }

}