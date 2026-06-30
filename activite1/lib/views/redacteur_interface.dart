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
  // 21. Récupération des valeurs saisies via les contrôleurs de texte
  Future<void> _ajouterRedacteur() async {
    // 22. Vérification que les champs ne sont pas vides
    if (_nomController.text.trim().isEmpty ||
        _prenomController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      
      // Notification visuelle si un champ est vide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // 23. Création d'un objet Redacteur sans id (l'id est omis, donc nul par défaut)
    final nouveauRedacteur = Redacteur(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
    );

    // 24. Appel de la méthode insertRedacteur de DatabaseManager
    await DatabaseManager.instance.insertRedacteur(nouveauRedacteur);
    
    // 26. Vider les champs de texte si l'ajout s'est bien passé
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();

    // 25. Rafraîchir la liste affichée après l'ajout (appelle setState en interne)
    _chargerRedacteurs(); 
  }


  // Fonction pour afficher la boîte de dialogue de modification
  // 27. Déclencher l'ouverture de la boîte de dialogue (Appelée par l'icône Modifier du ListTile)
  void _ouvrirDialogueModification(Redacteur redacteur) {
    // 28. Création de nouveaux contrôleurs pré-remplis avec les valeurs actuelles du rédacteur
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
              // 29. Permettre à l'utilisateur de modifier les valeurs dans les champs
              TextField(controller: modifNomController, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: modifPrenomController, decoration: const InputDecoration(labelText: 'Prénom')),
              TextField(controller: modifEmailController, decoration: const InputDecoration(labelText: 'E-mail')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Ferme la boîte sans enregistrer
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              // 30. Création d'un objet avec l'ID existant et les nouvelles valeurs saisies
              final redacteurModifie = Redacteur(
                id: redacteur.id, // ID conservé pour cibler la bonne ligne SQLite
                nom: modifNomController.text.trim(),
                prenom: modifPrenomController.text.trim(),
                email: modifEmailController.text.trim(),
              );
              
              // Validation des changements dans la base de données
              await DatabaseManager.instance.updateRedacteur(redacteurModifie);
              
              Navigator.pop(context); // Ferme la boîte de dialogue après la mise à jour
              
              // 31. Rafraîchir la liste à l'écran
              _chargerRedacteurs();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }


  // Fonction pour valider la suppression après confirmation
  // 32. Affichage d'une boîte de dialogue de confirmation (Appelée par l'icône Supprimer)
  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        // 33. Demande explicite de confirmation à l'utilisateur
        content: const Text('Voulez-vous vraiment supprimer ce rédacteur ?'),
        actions: [
          // Bouton d'annulation : ferme la boîte sans aucune action sur la BDD
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          // 34. Si la réponse est positive (clic sur Supprimer)
          TextButton(
            onPressed: () async {
              // Appel de la méthode de suppression selon l'ID unique
              await DatabaseManager.instance.deleteRedacteur(id);
              
              Navigator.pop(context); // Fermeture de la boîte de dialogue
              
              // 35. Rechargement immédiat de la liste à l'écran
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
