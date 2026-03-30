import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'mozaic_puzzle_screen.dart';
import '../services/ai_service.dart';
import '../data/album_data.dart';
import '../widgets/bottom_nav_widget.dart';

class SelectImageScreen extends StatefulWidget {
  const SelectImageScreen({super.key});

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  final List<Map<String, String>> images = const [
    {'path': 'assets/images/tunis-bab-bahr.jpg', 'title': 'Beb Bhar 🕌', 'subtitle': 'Porte de la mer de Tunis'},
    {'path': 'assets/images/nabeul-centre.jpg', 'title': 'Nabeul Centre 🏛️', 'subtitle': 'Cœur historique de Nabeul'},
    {'path': 'assets/images/nabeul-jarra.jpg', 'title': 'Nabeul Jarra 🏺', 'subtitle': 'Patrimoine potier tunisien'},
    {'path': 'assets/images/babys.jpg', 'title': 'Tenue traditionnelle pour enfant 👶', 'subtitle': 'Culture traditionnelle'},
    {'path': 'assets/images/brik tounsi.webp', 'title': 'Brik Tounsi 🥘', 'subtitle': 'Spécialité culinaire'},
    {'path': 'assets/images/catedral.jpg', 'title': 'Cathédrale 🏰', 'subtitle': 'Architecture coloniale'},
    {'path': 'assets/images/couscous.jpg', 'title': 'Couscous 🍲', 'subtitle': 'Plat national tunisien'},
    {'path': 'assets/images/drapeau.jpg', 'title': 'Drapeau 🇹🇳', 'subtitle': 'Emblème national'},
    {'path': 'assets/images/effah.jpg', 'title': 'épices 🎭', 'subtitle': 'Spécialité culinaire'},
    {'path': 'assets/images/el-jam.jpg', 'title': 'Amphithéâtre El Jem 🏛️', 'subtitle': 'Monument romain'},
    {'path': 'assets/images/fokhar.webp', 'title': 'Fokhar 🏺', 'subtitle': 'Poterie traditionnelle'},
    {'path': 'assets/images/guellala.jpg', 'title': 'Guellala 🏜️', 'subtitle': 'Oasis du sud'},
    {'path': 'assets/images/hammamet1.webp', 'title': 'Hammamet 🏖️', 'subtitle': 'Destination balnéaire'},
    {'path': 'assets/images/henna.webp', 'title': 'Henna 💅', 'subtitle': 'Art corporel traditionnel'},
    {'path': 'assets/images/kaak-warka.jpg', 'title': 'Kaak Warka 🥐', 'subtitle': 'Pâtisserie tunisienne'},
    {'path': 'assets/images/kafteji.png', 'title': 'Kafteji 🍴', 'subtitle': 'Spécialité locale'},
    {'path': 'assets/images/kbelli.jpeg', 'title': 'Kbelli 🎨', 'subtitle': 'Art du cuir'},
    {'path': 'assets/images/kholkhal.jpeg', 'title': 'Kholkhal 💍', 'subtitle': 'Bijoux traditionnels'},
    {'path': 'assets/images/korbous.jpeg', 'title': 'Korbous 🌊', 'subtitle': 'Plage côtière'},
    {'path': 'assets/images/mahdia.jpg', 'title': 'Mahdia 🏖️', 'subtitle': 'Port historique'},
    {'path': 'assets/images/map.jpeg', 'title': 'Carte Tunisie 🗺️', 'subtitle': 'Géographie nationale'},
    {'path': 'assets/images/medenine.jpg', 'title': 'Medenine 🏜️', 'subtitle': 'Architecture du sud'},
    {'path': 'assets/images/medina-1.jpg', 'title': 'Médina 🏛️', 'subtitle': 'Vieille ville historique'},
    {'path': 'assets/images/monastir.jpg', 'title': 'Monastir 🕌', 'subtitle': 'Cité côtière'},
    {'path': 'assets/images/mosaic bardo.jpeg', 'title': 'Mosaïques Bardo 🎨', 'subtitle': 'Trésors romains'},
    {'path': 'assets/images/musé-bardo.jpg', 'title': 'Musée Bardo 🏛️', 'subtitle': 'Patrimoine national'},
    {'path': 'assets/images/nabeul1.jpg', 'title': 'Nabeul 🌊', 'subtitle': 'Perle du Cap Bon'},
    {'path': 'assets/images/okba.jpg', 'title': ':Mousquée Okba 🕌', 'subtitle': 'Monument religieux'},
    {'path': 'assets/images/sahara.jpg', 'title': 'Sahara 🏜️', 'subtitle': 'Désert tunisien'},
    {'path': 'assets/images/sefseri.webp', 'title': 'Sefseri 🎭', 'subtitle': 'Costume traditionnel'},
    {'path': 'assets/images/sfax.webp', 'title': 'Sfax 🏭', 'subtitle': 'Centre économique'},
    {'path': 'assets/images/sidi-bousaid.webp', 'title': 'Sidi Bousaid 🏘️', 'subtitle': 'Village pittoresque'},
    {'path': 'assets/images/slata-mechwiya.jpg', 'title': 'Salade Méchouia 🥗', 'subtitle': 'Cuisine traditionnelle'},
    {'path': 'assets/images/souk.jpg', 'title': 'Souk 🛍️', 'subtitle': 'Marché traditionnel'},
    {'path': 'assets/images/sousse.webp', 'title': 'Sousse 🏖️', 'subtitle': 'Perle du Sahel'},
    {'path': 'assets/images/tataouine.jpg', 'title': 'Tataouine 🏜️', 'subtitle': 'Ksars du sud'},
    {'path': 'assets/images/tozeur1.jpg', 'title': 'Tozeur 🌴', 'subtitle': 'Oasis du Jérid'},
    {'path': 'assets/images/tunis1.webp', 'title': 'Tunis 🏛️', 'subtitle': 'Capitale tunisienne'},
    {'path': 'assets/images/tunis2.jpg', 'title': 'Tunis Médina 🕌', 'subtitle': 'Cœur de Tunis'},
    {'path': 'assets/images/yassmine.jpeg', 'title': 'Yasmine Hammamet 🌹', 'subtitle': 'Station balnéaire'},
    {'path': 'assets/images/zarzis.jpg', 'title': 'Zarzis 🏖️', 'subtitle': 'Plage du sud'},
    {'path': 'assets/images/felfel.webp', 'title': 'Felfel 🌶️', 'subtitle': 'Piment tunisien épicé'},
    {'path': 'assets/images/Machmoum.jpg', 'title': 'Machmoum 🌸', 'subtitle': 'Bouquet de jasmin traditionnel'},
    {'path': 'assets/images/El-Khomsa.jpeg', 'title': 'Khomsa 🪬', 'subtitle': 'Symbole protecteur tunisien'},
  ];

  // Set<String> favoris = {}; // 🌟 Favoris - removed, using AlbumData directly
  
  final String n8nWebhookUrl = "https://alec-nonaquatic-miesha.ngrok-free.dev/webhook/puzzle-ai"; 

  // 🔥 Flag pour éviter les clics multiples
  bool _isProcessingFavorite = false; 

  void showModernSnackbar(String message) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } catch (e) {
      // 🔥 Gestion d'erreur pour les snackbars
      debugPrint('Erreur lors de l\'affichage du snackbar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Écouter les changements de AlbumData pour mettre à jour l'UI automatiquement
    context.watch<AlbumData>();
    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const BottomNavWidget(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2E), Color(0xFF3A0CA3), Color(0xFF4361EE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🏛️ Header
              const Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🇹🇳', style: TextStyle(fontSize: 40)),
                        SizedBox(width: 12),
                        Text('Tunisie', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(width: 12),
                        Text('🇹🇳', style: TextStyle(fontSize: 40)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choisissez une image pour votre puzzle',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🏺', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text('🕌', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text('🏛️', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text('🇹🇳', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ],
                ),
              ),

              // 📸 Grid d'images
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final imagePath = image['path'];
                      final imageTitle = image['title'];
                      
                      // 🔥 Éviter les exceptions si les données sont nulles
                      if (imagePath == null || imageTitle == null) {
                        return const SizedBox(); // Retourner un widget vide en cas de données invalides
                      }
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MosaicPuzzleScreen(
                                imagePath: imagePath,
                                imageName: imageTitle,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                setState(() {});
                              });
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  // 🔥 Gestion d'erreur pour les images manquantes
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported, color: Colors.white54, size: 40),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Overlay dégradé
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            // Titre
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(imageTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(image['subtitle'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                            /// ⭐ FAVORI
                            Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      // 🔥 Éviter les clics multiples qui peuvent bloquer l'app
                                      if (_isProcessingFavorite) return;
                                      _isProcessingFavorite = true;

                                      try {
                                        if (AlbumData.exists(imagePath)) {
                                          AlbumData.removeByPath(imagePath);
                                          showModernSnackbar("Supprimé de l'album ⭐");
                                        } else {
                                          showModernSnackbar("Ajouté à l'album ⭐");
                                          
                                          AlbumData.addItem(
                                            imagePath: imagePath,
                                            title: imageTitle,
                                            description: "Génération de la description...",
                                          );
                                          
                                          // Lancer la génération AI en arrière-plan
                                          Future(() async {
                                            try {
                                              final desc = await AiService.generateDescription(
                                                title: imageTitle,
                                              );
                                              AlbumData.updateDescriptionByPath(imagePath, desc);
                                            } catch (e) {
                                              // 🔥 Gestion d'erreur pour l'AI
                                              AlbumData.updateDescriptionByPath(imagePath, "Description indisponible");
                                            }
                                          });
                                        }
                                      } catch (e) {
                                        // 🔥 Gestion d'erreur pour éviter le blocage
                                        showModernSnackbar("Erreur lors de l'opération");
                                      } finally {
                                        // 🔥 Réactiver les clics après un court délai
                                        Future.delayed(const Duration(milliseconds: 300), () {
                                          if (mounted) {
                                            _isProcessingFavorite = false;
                                          }
                                        });
                                      }
                                    },
                                    child: Icon(
                                      // Calcul direct pour une réactivité immédiate
                                      AlbumData.exists(imagePath) ? Icons.star : Icons.star_border,
                                      color: Colors.yellow,
                                      size: 28,
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),            
            ],
          ),
        ),
      ),
    );
  }
}
