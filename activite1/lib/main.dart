import 'package:flutter/material.dart';
import 'views/redacteur_interface.dart'; // Importation de la future vue

void main() {
  // Garantit que les services Flutter (comme SQLite) sont initialisés avant le lancement
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false, // Désactive la bannière de débogage
      theme: ThemeData(
        primarySwatch: Colors.pink, // Conserve la couleur fuchsia/rose de ton magazine
        useMaterial3: true,
      ),
      home: const RedacteurInterface(), // Définit l'interface des rédacteurs comme page d'accueil
    );
  }
}
