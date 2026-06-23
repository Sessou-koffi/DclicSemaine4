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
      debugShowCheckedModeBanner: false, // Désactive la bannière de débogage
      theme: ThemeData(
        // Utilise la couleur rose/fuchsia de la capture d'écran
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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink, // Couleur conforme à la Figure 1
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Action du menu (vide pour le moment)
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Action de recherche (vide pour le moment)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Charge l'image depuis ton dossier local assets
            // Remplace 'magazineInfo.jpg' par le nom exact de ton fichier image
            Image.asset(
              'assets/images/magazineInfo.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink, // Couleur conforme à la Figure 1
        onPressed: () {
          // Affiche le message demandé dans la console de débogage
          print('Tu as cliqué dessus');
        },
        child: const Text(
          'click',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
