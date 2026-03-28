

import 'package:flutter/material.dart';
import 'mozaic_puzzle_screen.dart';

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
    {'path': 'assets/images/hammamet2.jpeg', 'title': 'Hammamet Médina 🌅', 'subtitle': 'Vieille ville côtière'},
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
  ];

  Set<String> favoris = {}; // 🌟 Favoris

  /// 🔗 EXEMPLE WEBHOOK POUR N8N
  final String n8nWebhookUrl = "http://localhost:5678/webhook-test/puzzle-ai"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          child: Column(
            children: [
              // 🔙 Retour
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ),

              // 🏛️ Header
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🇹🇳',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Tunisie',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '🇹🇳',
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choisissez une image pour votre puzzle',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Row(
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
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final isFavorite = favoris.contains(image['path']);
                      return GestureDetector(
                        onTap: () {
                          // 🖼 Passage à MosaicPuzzleScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MosaicPuzzleScreen(
                                imagePath: image['path']!,
                                //n8nWebhookUrl: n8nWebhookUrl, // 🌐 Envoi n8n
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(image['path']!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
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
                                  Text(
                                    image['title']!,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    image['subtitle']!,
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // Bouton favori
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isFavorite) {
                                      favoris.remove(image['path']);
                                    } else {
                                      favoris.add(image['path']!);
                                    }
                                  });
                                },
                                child: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: Colors.yellowAccent,
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
              // Bottom decoration
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🌟', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 16),
                    Text(
                      'Puzzle Art Tunisien',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('🌟', style: TextStyle(fontSize: 24)),
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