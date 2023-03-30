import 'package:flutter/material.dart';
import 'package:qr_scan/screens/scan_tiles.dart';

//Pantalla donde se mostrará una lista con todas las direcciones escaneadas
class MapasScreen extends StatelessWidget {
  const MapasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(tipus: 'geo');
  }
}
