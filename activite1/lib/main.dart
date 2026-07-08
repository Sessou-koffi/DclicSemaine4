import 'package:flutter/material.dart';
import 'views/redacteur_interface.dart';
import 'services/database_factory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDatabaseFactory();

  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const RedacteurInterface(),
    );
  }
}
