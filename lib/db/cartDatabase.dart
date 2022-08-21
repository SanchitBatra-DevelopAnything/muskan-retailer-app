import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/cart.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();

  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = "REAL NOT NULL";

    await db.execute('''
CREATE TABLE $tableCart ( 
  ${CartFields.id} $idType,
  ${CartFields.itemId} $textType, 
  ${CartFields.title} $textType,
  ${CartFields.quantity} $doubleType,
  ${CartFields.price} $textType,
  ${CartFields.parentSubcategoryType} $textType,
  ${CartFields.imageUrl} $textType,
  ${CartFields.parentCategoryType} $textType,
  ${CartFields.totalPrice} $doubleType,
  )
''');
  }

  Future<CartItem> create(CartItem cartItem) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableCart, cartItem.toJson());
    return cartItem.copy(id: id);
  }

  Future<CartItem> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCart,
      columns: CartFields.values,
      where: '${CartFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CartItem.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<CartItem>> readAllNotes() async {
    final db = await instance.database;

    // final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableCart);

    return result.map((json) => CartItem.fromJson(json)).toList();
  }

  Future<int> update(CartItem cartItem) async {
    final db = await instance.database;

    return db.update(
      tableCart,
      cartItem.toJson(),
      where: '${CartFields.id} = ?',
      whereArgs: [cartItem.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCart,
      where: '${CartFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
