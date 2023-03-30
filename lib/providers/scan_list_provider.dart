//Clase que servirá de interfaz entre la clase que opera sobre la BDD y el resto de la app. Será un provider de db_provider
import 'package:flutter/cupertino.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/models/scan_model.dart';

class ScanListProvider extends ChangeNotifier {
  //Esta lista contendrá todos los ScanModel de tipo mapa cuando se ejecute la pantalla de mapas de la app y todos los ScanModel de tipo direcciones cuando se ejecute la pantalla de direcciones
  List<ScanModel> scans = [];
  //La variable tipusSeleccionat cambiará dependiendo del tipo de ScanModel seleccionado
  String tipusSeleccionat = 'http';

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    //Se instancia la clase DBProvider y se le asigna a su atributo id el que devuelve el método al crearlo, que es el que le toca en la BDD
    //Esto sirve para que cuando se llame este método .nouScan() desde la pantalla principal y llegue el siguiente escaneado (mapa o dirección), se almacene en la BDD con el tipo que toca y se muestre en la pantalla que toca, al añadirse a la lista adecuada
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if (nouScan.tipus == tipusSeleccionat) {
      this.scans.add(nouScan);
      //En ese momento hay que llamar al método .notifyListeners() para que actualice todos los métodos async que escuchen cuando se crea un ScanModel nuevo
      //Si no se hace esto, en la pantalla no aparecerá nada nuevo, aunque la BDD se actualice, porque los widgets no recargarán su información
      notifyListeners();
    }
    return nouScan;
  }

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    //El spread operator "..." sirve para añadir a una lista un número no declarado de elementos que forman parte de otra lista, todos los que haya en una lista por ejemplo
    //Si la lista a incluir puede ser nula se utiliza null-aware spread operator ...?
    this.scans = [...scans];
    notifyListeners();
  }

  //Se cargan los ScanModel de un tipo concreto: mapa o direccion
  carregaScanPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScansByTipus(tipus);
    this.scans = [...scans];
    this.tipusSeleccionat = tipus;
    notifyListeners();
  }

  //Se borran todos los registros
  esborraTots() async {
    final scans = await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  //Se borra solamente un ScanModel, dado su id
  esborraPerId(int id) async {
    final scans = await DBProvider.db.deleteScan(id);
    notifyListeners();
  }
}
