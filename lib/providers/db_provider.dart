import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/scan_model.dart';

class DBProvider {
  //Variable de tipo Database
  ///Las variables que empiezan por _ son siempre variables estáticas
  static Database? _database;
  //Atributo que inicializa siempre la instancia que se va a devolver, usando el constructor privado (DBProvider._())
  //Esta clase devuelve una instancia de la propia clase, siempre la misma, al inicializarse dentro de la misma clase usando un constructor privado
  static final DBProvider db = DBProvider._();

  //Constructor privado de la clase
  DBProvider._();

  Future<Database> get database async {
    //Si la BDD no está inicializada se crea y se retorna y si está inicializada, simplemente se retorna (sin inicializar)
    if (_database == null) _database = await initDB();

    return _database!;
  }

  //Este método inicializa la base de datos. Es asíncrono porque puede llamarse una vez ya esté funcionando el programa
  Future<Database> initDB() async {
    //Obtener ruta donde se crea la BDD
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,
        'Scans.db'); //path almacena la ruta donde se almacena la BDD
    print(path);
    //Creación de la BDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        //Aquí se crea la BDD
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

//insert de todos los valores de un escaneado
  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;

    final response = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor
      Values($id, $tipus, $valor))
    ''');
    return response;
  }

//
  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;

    final response = await db.insert('Scans', nouScan.toMap());
    print(response);
    return response;
  }

//Select de toda la tabla
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    //.query(table) devuelve toda la tabla que se indica como parámetro en una lista
    final response = await db.query('Scans');
    //e sería cada resgistro devuelto, si tiene valor devuelve una lista a partir del JSON con los elementos del registro y si está vacía devuelve una lista vacia "[]"
    return response.isNotEmpty
        ? response.map((e) => ScanModel.fromMap(e)).toList()
        : [];
  }

//Select de un registro concreto de la tabla por ID
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    //En esta llamada al método .query(), además de la tabla se le añaden más parámetros para restingir esa query: WHERE, ... para pasarle los valores d estas restricciones se usa whereArgs: []
    final response = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (response.isNotEmpty) {
      return ScanModel.fromMap(response.first);
    }
    //Para poder devolver un null en un método, debido al null safety, su variable debe ser "nullable", por eso se añade "?" al ScanModel de la definición del método
    return null;
  }

//Select de los registros de la tabla por tipus (devuelve lista de ScanModel)
  Future<List<ScanModel>> getScansByTipus(String tipus) async {
    final db = await database;
    //.query(table) devuelve toda la tabla que se indica como parámetro en una lista
    final response =
        await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);
    //e sería cada resgistro devuelto, si tiene valor devuelve una lista a partir del JSON con los elementos del registro y si está vacía devuelve una lista vacia "[]"
    return response.isNotEmpty
        ? response.map((e) => ScanModel.fromMap(e)).toList()
        : [];
  }

//Update que devuelve el id del registro que se modifica
  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    //Este método update() para modificar un registro de db tiene como argumentos la tabla y el registro a modificar, en este caso un objeto ScanModel y su ID
    final response = db.update('Scans', nouScan.toMap(),
        where: 'id = ', whereArgs: [nouScan.id]);
    return response;
  }

//Delete para borrar todos los registro de la tabla (papelera de HomePage)
  Future<int> deleteAllScans() async {
    final db = await database;
    //Se puede usar el método .delete() también, el raw implica escribir toda la query entre ''' query '''
    final response = await db.rawDelete('''
      DELETE FROM Scans
    ''');
    return response;
  }

//Delete que borra un solo registro por id
  Future<int> deleteScan(int id) async {
    final db = await database;
    final response = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return response;
  }
}
