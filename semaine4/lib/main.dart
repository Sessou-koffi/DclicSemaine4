import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const pageAccueil(),
    );
  }
}

class pageAccueil extends StatelessWidget {
  const pageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Magazine Infos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Image principale de couverture
            Image(
              image: AssetImage('assets/images/magazineInfo.png'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          print('Tu as cliqué dessus');
        },
        child: const Text(
          'Click',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// --- 1. CLASSE PARTIE TITRE ---
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Votre magazine numérique, votre source d\'inspiration',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// --- 2. CLASSE PARTIE TEXTE ---
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: const Text(
        'Magazine Infos est bien plus qu\'un simple magazine d\'informations. C\'est votre passerelle vers le monde, une source inestimable de connaissances et d\'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux mondiaux, la culture, la science, la, et voir même le divertissement (le jeux).',
        style: TextStyle(
          fontSize: 11,
          height: 1.4,
          color: Colors.black54,
        ),
        textAlign: TextAlign.justify, // Alignement propre comme sur la maquette
      ),
    );
  }
}

/// --- 3. CLASSE PARTIE ICONE ---
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // TEL
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.pink, size: 24),
                onPressed: () {},
              ),
              const Text('TEL', style: TextStyle(color: Colors.pink, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          // MAIL
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.email, color: Colors.pink, size: 24),
                onPressed: () {},
              ),
              const Text('MAIL', style: TextStyle(color: Colors.pink, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          // PARTAGE
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.pink, size: 24),
                onPressed: () {},
              ),
              const Text('PARTAGE', style: TextStyle(color: Colors.pink, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- 4. CLASSE PARTIE RUBRIQUE ---
/// --- 4. CLASSE PARTIE RUBRIQUE ---
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // CORRECTION : Utilisation de EdgeInsets.only pour cibler précisément les côtés
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Row(
        children: [
          // Image 1 (Gauche)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(
                image: AssetImage('assets/images/presse.png'),
                fit: BoxFit.cover,
                height: 130,
              ),
            ),
          ),
          const SizedBox(width: 15), // Espace séparateur
          // Image 2 (Droite)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(
                image: AssetImage('assets/images/mode.png'),
                fit: BoxFit.cover,
                height: 130,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

