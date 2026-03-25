class QuizQuestion {
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;

  const QuizQuestion({
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final explanation = (json['explanation'] ?? '').toString().trim();
    final correctIndex = (json['correctIndex'] ?? 0) as int;

    return QuizQuestion(
      category: (json['category'] ?? 'CULTURE').toString().toUpperCase().trim(),
      question: (json['question'] ?? '').toString().trim(),
      options: List<String>.from(json['options'] ?? []),
      correctIndex: correctIndex,
      difficulty: (json['difficulty'] ?? 'medium').toString(),

      // ✅ Fallback si explanation vide
      explanation: explanation.isNotEmpty
          ? explanation
          : 'La bonne réponse est : "${json['options']?[correctIndex] ?? ''}".',
    );
  }
}

class QuizLevel {
  final String name;
  final int timePerQuestion;
  final double scoreMultiplier;
  final String difficulty;

  const QuizLevel({
    required this.name,
    required this.timePerQuestion,
    required this.scoreMultiplier,
    required this.difficulty,
  });

}

class QuizResult {
  final int score;
  final int correct;
  final int total;
  final int maxCombo;
  final int xpEarned;
  final int playerLevel;
  final String levelName;
  final double accuracy;

  QuizResult({
    required this.score,
    required this.correct,
    required this.total,
    required this.maxCombo,
    required this.xpEarned,
    required this.playerLevel,
    required this.levelName,
    required this.accuracy,
  });

}

const List<QuizLevel> kQuizLevels = [
  QuizLevel(
    name: 'Débutant',
    timePerQuestion: 30,
    scoreMultiplier: 1.0,
    difficulty: 'Débutant',
  ),
  QuizLevel(
    name: 'Intermédiaire',
    timePerQuestion: 20,
    scoreMultiplier: 1.5,
    difficulty: 'Intermédiaire',
  ),
  QuizLevel(
    name: 'Expert',
    timePerQuestion: 12,
    scoreMultiplier: 2.0,
    difficulty: 'Expert',
  ),
];



/*const List<QuizQuestion> kQuizQuestions = [

  // ════════════════════════════════════════
  // DÉBUTANT (facile)
  // ════════════════════════════════════════

  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle est la capitale de la Tunisie?',
    options: ['Sfax', 'Sousse', 'Tunis', 'Bizerte'],
    correctIndex: 2,
    explanation: 'Tunis est la capitale et la plus grande ville de Tunisie.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'En quelle année la Tunisie a-t-elle obtenu son indépendance?',
    options: ['1956', '1962', '1948', '1960'],
    correctIndex: 0,
    explanation: 'La Tunisie a proclamé son indépendance le 20 mars 1956.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel est le plat national tunisien le plus emblématique?',
    options: ['Tajine', 'Couscous', 'Lablabi', 'Merguez'],
    correctIndex: 1,
    explanation: 'Le couscous est inscrit au patrimoine de l\'UNESCO depuis 2020.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle mer borde la Tunisie?',
    options: ['Mer Rouge', 'Mer Noire', 'Mer Méditerranée', 'Atlantique'],
    correctIndex: 2,
    explanation: 'La Tunisie est bordée par la Méditerranée sur environ 1300 km.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel sport est le plus populaire en Tunisie?',
    options: ['Basketball', 'Football', 'Tennis', 'Handball'],
    correctIndex: 1,
    explanation: 'Le football est le sport national, les Aigles de Carthage ont participé à plusieurs Coupes du Monde.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Qui était le premier président de la Tunisie?',
    options: ['Ben Ali', 'Marzouki', 'Bourguiba', 'Ben Salah'],
    correctIndex: 2,
    explanation: 'Habib Bourguiba, surnommé "le père de la nation", a dirigé la Tunisie de 1957 à 1987.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quel désert couvre le sud tunisien?',
    options: ['Sahel', 'Sahara', 'Kalahari', 'Namib'],
    correctIndex: 1,
    explanation: 'Le Sahara couvre environ 40% du territoire tunisien.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quelle est la langue officielle de la Tunisie?',
    options: ['Français', 'Amazigh', 'Arabe', 'Turc'],
    correctIndex: 2,
    explanation: 'L\'arabe est l\'unique langue officielle selon la Constitution tunisienne.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle industrie est un pilier de l\'économie tunisienne?',
    options: ['Automobile', 'Tourisme', 'Aérospatiale', 'Nucléaire'],
    correctIndex: 1,
    explanation: 'Le tourisme attire des millions de visiteurs chaque année en Tunisie.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle ville côtière est connue pour ses plages et son Medina classée UNESCO?',
    options: ['Bizerte', 'Tabarka', 'Sousse', 'Monastir'],
    correctIndex: 2,
    explanation: 'La Medina de Sousse est classée au patrimoine mondial de l\'UNESCO.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quelle cité antique était rivale de Rome?',
    options: ['Carthage', 'Memphis', 'Alexandrie', 'Cyrène'],
    correctIndex: 0,
    explanation: 'Carthage, aujourd\'hui banlieue de Tunis, fut détruite par Rome en 146 av. J.-C.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quel pays colonisait la Tunisie avant 1956?',
    options: ['Royaume-Uni', 'Italie', 'Espagne', 'France'],
    correctIndex: 3,
    explanation: 'La Tunisie était un protectorat français depuis le Traité du Bardo en 1881.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle île tunisienne est célèbre pour son tourisme balnéaire?',
    options: ['Galite', 'Djerba', 'Zembra', 'Kuriat'],
    correctIndex: 1,
    explanation: 'Djerba est la plus grande île d\'Afrique du Nord et un haut lieu touristique.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle est la principale ressource minière exportée par la Tunisie?',
    options: ['Pétrole', 'Phosphate', 'Fer', 'Cuivre'],
    correctIndex: 1,
    explanation: 'La Tunisie est l\'un des plus grands producteurs mondiaux de phosphate.',
    difficulty: 'Débutant',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel festival se tient chaque été près de Tunis?',
    options: ['Festival de Sfax', 'Festival de Dougga', 'Festival de Carthage', 'Tabarka Jazz'],
    correctIndex: 2,
    explanation: 'Le Festival International de Carthage est organisé depuis 1964.',
    difficulty: 'Débutant',
  ),

  // ════════════════════════════════════════
  // INTERMÉDIAIRE
  // ════════════════════════════════════════

  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Comment s\'appelle la révolution tunisienne de 2010-2011?',
    options: ['Révolution des Jasmins', 'Printemps Arabe', 'Révolution du Pain', 'Intifada'],
    correctIndex: 0,
    explanation: 'La Révolution des Jasmins, déclenchée par Mohamed Bouazizi, a renversé Ben Ali.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quel est le point culminant de la Tunisie?',
    options: ['Djebel Chambi', 'Djebel Zaghouan', 'Djebel Bou Hedma', 'Djebel Selloum'],
    correctIndex: 0,
    explanation: 'Le Djebel Chambi culmine à 1544 mètres près de Kasserine.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quelle année Ben Ali a-t-il pris le pouvoir en Tunisie?',
    options: ['1981', '1987', '1992', '1979'],
    correctIndex: 1,
    explanation: 'Zine El Abidine Ben Ali a renversé Bourguiba le 7 novembre 1987.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle ville est la capitale économique de la Tunisie?',
    options: ['Tunis', 'Sfax', 'Sousse', 'Gabès'],
    correctIndex: 1,
    explanation: 'Sfax est la deuxième ville et la capitale économique de la Tunisie.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel instrument est emblématique de la musique traditionnelle tunisienne?',
    options: ['Oud', 'Banjo', 'Sitar', 'Balafon'],
    correctIndex: 0,
    explanation: 'L\'oud, luth arabe, est au cœur de la musique andalouse et malouf tunisien.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Avec quels pays la Tunisie partage-t-elle ses frontières?',
    options: ['Maroc et Algérie', 'Algérie et Libye', 'Libye et Égypte', 'Maroc et Libye'],
    correctIndex: 1,
    explanation: 'La Tunisie est frontalière avec l\'Algérie à l\'ouest et la Libye au sud-est.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quel traité a établi le protectorat français sur la Tunisie?',
    options: ['Traité de Paris', 'Traité du Bardo', 'Traité de Fès', 'Accord d\'Évian'],
    correctIndex: 1,
    explanation: 'Le Traité du Bardo signé en 1881 a établi le protectorat français en Tunisie.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel style de musique classique est typiquement tunisien?',
    options: ['Raï', 'Malouf', 'Gnawa', 'Chaabi'],
    correctIndex: 1,
    explanation: 'Le Malouf est un genre musical tunisien d\'origine andalouse, classé patrimoine immatériel.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle ville tunisienne abrite les ruines romaines de Dougga?',
    options: ['Béja', 'Testour', 'Téboursouk', 'Siliana'],
    correctIndex: 2,
    explanation: 'Dougga, près de Téboursouk, est le site romain le mieux conservé d\'Afrique du Nord.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle est la monnaie officielle de la Tunisie?',
    options: ['Dirham', 'Dinar', 'Livre', 'Franc'],
    correctIndex: 1,
    explanation: 'Le dinar tunisien (TND) est la monnaie nationale depuis l\'indépendance.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Qui a fondé la ville de Carthage selon la légende?',
    options: ['Hannibal', 'Didon', 'Massinissa', 'Jugurtha'],
    correctIndex: 1,
    explanation: 'Selon la légende, la reine phénicienne Didon (Élissa) a fondé Carthage vers 814 av. J.-C.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel écrivain tunisien a reçu le Prix Nobel de Littérature?',
    options: ['Mahmoud Messadi', 'Albert Memmi', 'Hedi Bouraoui', 'Aucun pour l\'instant'],
    correctIndex: 3,
    explanation: 'Aucun auteur tunisien n\'a encore reçu le Prix Nobel de Littérature à ce jour.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Où se trouve le lac de Tunis?',
    options: ['Au nord de Sfax', 'Au centre de Kairouan', 'Entre Tunis et la mer', 'Près de Bizerte'],
    correctIndex: 2,
    explanation: 'Le lac de Tunis sépare la capitale de la banlieue nord et de la mer Méditerranée.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quel général carthaginois a traversé les Alpes avec des éléphants?',
    options: ['Hamilcar', 'Hannibal', 'Hasdrubal', 'Magon'],
    correctIndex: 1,
    explanation: 'Hannibal Barca a traversé les Alpes en 218 av. J.-C. pour attaquer Rome par le nord.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quel secteur emploie le plus de Tunisiens?',
    options: ['Industrie', 'Agriculture', 'Services', 'Mines'],
    correctIndex: 2,
    explanation: 'Le secteur des services (tourisme, commerce, administration) emploie la majorité des actifs tunisiens.',
    difficulty: 'Intermédiaire',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel est le nom du vêtement traditionnel tunisien porté par les hommes?',
    options: ['Djellaba', 'Jebba', 'Burnous', 'Gandoura'],
    correctIndex: 1,
    explanation: 'La jebba est le vêtement traditionnel tunisien masculin, souvent portée lors des fêtes.',
    difficulty: 'Intermédiaire',
  ),

  // ════════════════════════════════════════
  // EXPERT (difficile)
  // ════════════════════════════════════════

  QuizQuestion(
    category: 'HISTOIRE',
    question: 'En quelle année le Néo-Destour a-t-il été fondé par Bourguiba?',
    options: ['1920', '1934', '1944', '1952'],
    correctIndex: 1,
    explanation: 'Le Néo-Destour, parti indépendantiste, a été fondé le 2 mars 1934 à Ksar Hellal.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle est la superficie approximative de la Tunisie en km²?',
    options: ['103 000', '163 610', '215 000', '88 000'],
    correctIndex: 1,
    explanation: 'La Tunisie couvre 163 610 km², ce qui en fait un pays de taille moyenne en Afrique.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quel souverain aghlabide a ordonné la construction de la Grande Mosquée de Kairouan?',
    options: ['Ibrahim I', 'Ziyadat Allah I', 'Ziadat Allah III', 'Ahmad ibn Aghlabide'],
    correctIndex: 0,
    explanation: 'Ibrahim I ibn Aghlabide a fondé la Grande Mosquée de Kairouan en 836, agrandie par ses successeurs.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quel pourcentage du PIB tunisien le tourisme représentait-il avant 2011?',
    options: ['3%', '7%', '14%', '20%'],
    correctIndex: 2,
    explanation: 'Le tourisme représentait environ 14% du PIB tunisien avant les crises politiques de 2011.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel philosophe islamique médiéval est né à Tunis en 1332?',
    options: ['Averroès', 'Ibn Khaldoun', 'Al-Farabi', 'Ibn Rushd'],
    correctIndex: 1,
    explanation: 'Ibn Khaldoun, né à Tunis en 1332, est l\'auteur de la Muqaddima, précurseur des sciences sociales.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Lors de quelle guerre Hannibal fut-il finalement vaincu sur le sol tunisien?',
    options: ['Première Guerre Punique', 'Deuxième Guerre Punique', 'Troisième Guerre Punique', 'Guerre de Jugurtha'],
    correctIndex: 1,
    explanation: 'Hannibal fut vaincu à la bataille de Zama en 202 av. J.-C. par Scipion l\'Africain, mettant fin à la 2e Guerre Punique.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quel est le nom du golfe situé au nord-est de la Tunisie?',
    options: ['Golfe de Gabès', 'Golfe de Tunis', 'Golfe de Hammamet', 'Golfe de Bizerte'],
    correctIndex: 1,
    explanation: 'Le Golfe de Tunis, au nord-est, est l\'un des deux grands golfes tunisiens avec le Golfe de Gabès.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel architecte a conçu le Musée National du Bardo?',
    options: ['Jean-Émile Resplandy', 'Sinon Bône', 'Victor Valensi', 'Olivier Clément Cacoub'],
    correctIndex: 3,
    explanation: 'Olivier Clément Cacoub, architecte franco-tunisien, a réalisé de nombreux bâtiments emblématiques en Tunisie.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quelle constitution tunisienne a été adoptée après la révolution de 2011?',
    options: ['Constitution de 1959', 'Constitution de 2014', 'Constitution de 2018', 'Constitution de 2022'],
    correctIndex: 1,
    explanation: 'La Constitution de 2014, saluée internationalement, a établi un régime démocratique après la révolution.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle organisation régionale regroupe la Tunisie avec ses voisins maghrébins?',
    options: ['CEDEAO', 'Union du Maghreb Arabe', 'Ligue Arabe', 'Union Africaine'],
    correctIndex: 1,
    explanation: 'L\'Union du Maghreb Arabe (UMA), fondée en 1989, regroupe Maroc, Algérie, Tunisie, Libye et Mauritanie.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'GÉOGRAPHIE',
    question: 'Quelle chott (lac salé) est la plus grande dépression de Tunisie?',
    options: ['Chott el-Fejaj', 'Chott el-Jérid', 'Chott el-Gharsa', 'Sebkhet en-Noual'],
    correctIndex: 1,
    explanation: 'Le Chott el-Jérid est le plus grand lac salé d\'Afrique du Nord, situé dans le sud tunisien.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel cinéaste tunisien est célèbre pour le film "Les Silences du Palais"?',
    options: ['Nouri Bouzid', 'Moufida Tlatli', 'Férid Boughedir', 'Abdellatif Kechiche'],
    correctIndex: 1,
    explanation: 'Moufida Tlatli a réalisé "Les Silences du Palais" en 1994, un chef-d\'œuvre du cinéma arabe.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'HISTOIRE',
    question: 'Quelle organisation a décerné le Prix Nobel de la Paix 2015 à un groupe tunisien?',
    options: ['ONU', 'UNESCO', 'Quartet du Dialogue National', 'Amnesty International'],
    correctIndex: 2,
    explanation: 'Le Quartet du Dialogue National tunisien a reçu le Prix Nobel de la Paix 2015 pour sa contribution à la démocratie.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'ÉCONOMIE',
    question: 'Quelle zone franche industrielle est la plus importante en Tunisie?',
    options: ['Zone de Sfax', 'Zone de Bizerte', 'Zone de Gabès', 'Zone de Sousse'],
    correctIndex: 1,
    explanation: 'La zone franche de Bizerte (UTICA) est l\'une des plus importantes zones industrielles de Tunisie.',
    difficulty: 'Expert',
  ),
  QuizQuestion(
    category: 'CULTURE',
    question: 'Quel est le nom de la médina de Tunis classée UNESCO depuis quelle année?',
    options: ['1979', '1988', '1992', '2001'],
    correctIndex: 0,
    explanation: 'La Médina de Tunis est classée au patrimoine mondial de l\'UNESCO depuis 1979.',
    difficulty: 'Expert',
  ),
];*/