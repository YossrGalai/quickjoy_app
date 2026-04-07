# 🎮 QUICK_JOY — Learn & Play Tunisia 🧠🧩
## 📌 Résumé

QUICK_JOY est une application mobile développée avec Flutter, combinant apprentissage et divertissement à travers deux modes complémentaires :

🧠 Quiz intelligent sur la Tunisie
🧩 Puzzle interactif basé sur des images de la Tunisie

L’application met en valeur la richesse culturelle et visuelle de la Tunisie, tout en offrant une expérience immersive grâce à l’intégration de l’IA, des animations et du son.

## 🚀 Aperçu
Framework : Flutter (Dart)
Architecture : MVC + Provider
State Management : Provider
IA : Modèle LLM via Groq
Automation : n8n (gestion de l’album)
Multimédia : musique de fond + images locales
Expérience : interactive, éducative et ludique

## 🏗️ Architecture (Vue d’ensemble)
┌──────────────────────────────────────────────┐

│                UI (Flutter)                  │

│  - Home / Quiz / Puzzle / Album             │

│  - Animations & Widgets personnalisés       │

└───────────────┬──────────────────────────────┘

                │
                ▼
                
┌──────────────────────────────────────────────┐

│            Providers (State)                │

│  - GameProvider                            │

│  - QuizProvider                            │

└───────────────┬──────────────────────────────┘

                │
                ▼
┌──────────────────────────────────────────────┐

│        Services & Intelligence              │

│  - QuizService (Groq LLM)                  │

│  - PuzzleService                           │

│  - AI Service                             │

│  - n8n Automation                         │

└───────────────┬──────────────────────────────┘

                │
                ▼
                
┌──────────────────────────────────────────────┐

│               Data & Models                │

│  - Quiz / Puzzle Models                   │

│  - Tunisia Image Dataset                 │

└──────────────────────────────────────────────┘


# 🎯 Fonctionnalités
## 🧠 Mode Quiz — Explore la Tunisie
Questions générées dynamiquement via Groq (LLM)

Thématiques autour de la culture tunisienne

Système de score en temps réel

Feedback immédiat + écran de résultats

## 🧩 Mode Puzzle — Découvre la Tunisie visuellement
Images réelles de la Tunisie 🇹🇳

Découpage en mosaïque interactive

Mélange automatique des pièces

🎵 Musique de fond immersive

🎉 Animation de victoire

## 🖼️ Album intelligent
Les puzzles complétés sont sauvegardés automatiquement

Intégration avec n8n pour ajouter les images résolues à l’album

Suivi de progression visuelle

## 🎨 Expérience globale
Navigation fluide entre modes

UI moderne et intuitive

Composants réutilisables

Expérience immersive (son + visuel + interaction)

# 🔄 Pipeline de fonctionnement
## 🎮 Mode Quiz
Génération des questions via Groq API

Affichage interactif

Réponse utilisateur

Calcul du score

Affichage des résultats

## 🧩 Mode Puzzle
Sélection d’une image de la Tunisie

Découpage en tuiles

Mélange aléatoire

Interaction utilisateur

Vérification de complétion

🎉 Victoire + ajout à l’album via n8n

# 📂 Arborescence du projet
lib/

├── controllers/

│   └── quiz_controller.dart

│

├── data/

│   └── album_data.dart

│

├── models/

│   ├── album_item.dart

│   ├── puzzle_model.dart

│   └── quiz.dart

│

├── providers/

│   ├── game_provider.dart

│   └── quiz_provider.dart

│

├── router/

│   └── app_router.dart

│

├── screens/

│   ├── home_screen.dart

│   ├── quiz_screen.dart

│   ├── mozaic_puzzle_screen.dart

│   ├── result_screen.dart

│   ├── select_image_screen.dart

│   ├── album_screen.dart

│   └── splash_screen.dart

│

├── services/

│   ├── ai_service.dart

│   ├── puzzle_service.dart

│   └── quiz_service.dart

│

├── theme/

│   └── app_theme.dart

│

├── widgets/

│   ├── app_bar_widget.dart

│   ├── bottom_nav_widget.dart

│   ├── category_card.dart

│   ├── puzzle_tile.dart

│   ├── puzzle_clipper.dart

│   ├── quiz_widgets.dart

│   └── score_header.dart

│

├── app.dart

└── main.dart

# ⚙️ Configuration
1. Cloner le projet

git clone [<repo_url>](https://github.com/YossrGalai/quickjoy_app.git)

cd quick_joy

2. Installer les dépendances

flutter pub get

3. Configuration API (Groq)

Créer un fichier .env :
GROQ_API_KEY=your_api_key_here

## ▶️ Lancement
flutter run
## 🧪 Tests
flutter test
## 📸 Démo
Démo vidéo
