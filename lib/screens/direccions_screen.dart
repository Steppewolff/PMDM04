import 'package:flutter/material.dart';
import 'package:qr_scan/screens/scan_tiles.dart';

//Pantalla donde se mostrará una lista con todas las direcciones escaneadas
class DireccionsScreen extends StatelessWidget {
  const DireccionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Se devuelve el ListView Builder de la clase en la librería scan_tiles.dart, pasándole el argumento 'http' para que se muestren solamente las direcciones
    return ScanTiles(tipus: 'http');
  }
}
