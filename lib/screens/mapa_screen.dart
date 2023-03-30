import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/scan_model.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();

//Variables que almacenan el estado del objeto MapType y del icono a mostrar en el botón de tipo de Mapa
  MapType _displayedMapType = MapType.normal;
  var _iconButton = Icon(Icons.map);

//Método que modifica el tipo de mapa de Google Maps y el icono que aparece en el botón
  void _changeMapType2() {
    setState(() {
      final type = _displayedMapType;
      switch (type) {
        case MapType.normal:
          _displayedMapType = MapType.satellite;
          _iconButton = Icon(Icons.satellite);
          break;
        case MapType.satellite:
          _displayedMapType = MapType.terrain;
          _iconButton = Icon(Icons.terrain);
          break;
        case MapType.terrain:
          _displayedMapType = MapType.hybrid;
          _iconButton = Icon(Icons.network_cell);
          break;
        case MapType.hybrid:
          _displayedMapType = MapType.normal;
          _iconButton = Icon(Icons.map);
          break;
        default:
          _displayedMapType = MapType.normal;
          _iconButton = Icon(Icons.map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _puntoInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 14.4746,
    );

    Set<Marker> markers = new Set<Marker>();
    markers.add(
        new Marker(markerId: MarkerId('casa'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          child: _iconButton,
          onPressed: () {
            _changeMapType2();
          }),
      body: GoogleMap(
        mapType: _displayedMapType,
        myLocationButtonEnabled: true,
        markers: markers,
        initialCameraPosition: _puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
