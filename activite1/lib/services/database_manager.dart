import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  // Instance unique (Singleton) pour centraliser l'accès à la BDD
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  // Getter asynchrone pour récupérer la base de données ouverte
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('redacteurs.db');
    return _database!;
  }

  // Initialisation et ouverture de la base de données
  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      print("Erreur lors de l'initialisation de la BDD : $e");
      rethrow;
    }
  }

  // Structure de création de la table (exécutée une seule fois)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE redacteurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // --- MÉTHODES CRUD ---

  // 1. CREATE : Insérer un nouveau rédacteur
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.insert(
      'redacteurs', 
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Évite les crashs en cas de doublon
    );
  }

  // 2. READ : Récupérer tous les rédacteurs
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await instance.database;
    
    // Récupère toutes les lignes de la table sous forme de liste de Map
    final result = await db.query('redacteurs', orderBy: 'nom ASC');

    // Convertit chaque Map en objet Redacteur
    return result.map((json) => Redacteur.fromMap(json)).toList();
  }

  // 3. UPDATE : Modifier les informations d'un rédacteur existant
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // 4. DELETE : Supprimer un rédacteur selon son ID
  Future<int> deleteRedacteur(int id) async {
    final db = await instance.database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optionnel : Fermer la base de données proprement
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
