import 'package:flutter/material.dart';
import '../modele/redacteur.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  // 1. Déclaration des contrôleurs de texte pour les champs de saisie
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // 2. Liste dynamique locale pour stocker les rédacteurs chargés
  List<Redacteur> _redacteurs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs(); // Charge les données au démarrage de l'écran
  }

  @override
  void dispose() {
    // Libération des contrôleurs pour éviter les fuites de mémoire
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Fonction pour récupérer la liste des rédacteurs depuis SQLite
  Future<void> _chargerRedacteurs() async {
    setState(() => _isLoading = true);
    try {
      final donnees = await DatabaseManager.instance.getAllRedacteurs();
      setState(() {
        _redacteurs = donnees;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      setState(() => _isLoading = false);
    }
  }

  // Fonction pour ajouter un rédacteur
  Future<void> _ajouterRedacteur() async {
    if (_nomController.text.trim().isEmpty ||
        _prenomController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final nouveauRedacteur = Redacteur(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
    );

    await DatabaseManager.instance.insertRedacteur(nouveauRedacteur);
    
    // Réinitialisation des champs après insertion
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    _chargerRedacteurs(); // Rafraîchit l'affichage
  }

  // Fonction pour afficher la boîte de dialogue de modification
  void _ouvrirDialogueModification(Redacteur redacteur) {
    final TextEditingController modifNomController = TextEditingController(text: redacteur.nom);
    final TextEditingController modifPrenomController = TextEditingController(text: redacteur.prenom);
    final TextEditingController modifEmailController = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le rédacteur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: modifNomController, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: modifPrenomController, decoration: const InputDecoration(labelText: 'Prénom')),
              TextField(controller: modifEmailController, decoration: const InputDecoration(labelText: 'E-mail')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final redacteurModifie = Redacteur(
                id: redacteur.id,
                nom: modifNomController.text.trim(),
                prenom: modifPrenomController.text.trim(),
                email: modifEmailController.text.trim(),
              );
              await DatabaseManager.instance.updateRedacteur(redacteurModifie);
              Navigator.pop(context);
              _chargerRedacteurs();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  // Fonction pour valider la suppression après confirmation
  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce rédacteur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseManager.instance.deleteRedacteur(id);
              Navigator.pop(context);
              _chargerRedacteurs();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Rédacteurs', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- ZONE SUPÉRIEURE : CHAMPS DE SAISIE ---
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            
            // BOUTON D'AJOUT
            ElevatedButton.icon(
              onPressed: _ajouterRedacteur,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un rédacteur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- ZONE INFÉRIEURE : LISTE DYNAMIQUE ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _redacteurs.isEmpty
                      ? const Center(child: Text('Aucun rédacteur enregistré.'))
                      : ListView.builder(
                          itemCount: _redacteurs.length,
                          itemBuilder: (context, index) {
                            final redacteur = _redacteurs[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink.shade100,
                                  child: Text(redacteur.nom[0].toUpperCase()),
                                ),
                                title: Text('${redacteur.prenom} ${redacteur.nom.toUpperCase()}'),
                                subtitle: Text(redacteur.email),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _ouvrirDialogueModification(redacteur),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmerSuppression(redacteur.id!),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
