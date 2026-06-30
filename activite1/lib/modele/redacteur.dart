class Redacteur {
  // L'id est nullable (int?) car il est absent avant l'insertion en BDD
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  // 1. Constructeur principal (avec tous les attributs, id optionnel)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // 2. Méthode toMap() : Convertit l'objet en Map pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // On n'inclut l'id que s'il existe déjà
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // 3. Méthode de fabrique fromMap() : Reconstruit l'objet à partir d'une ligne SQLite
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}
