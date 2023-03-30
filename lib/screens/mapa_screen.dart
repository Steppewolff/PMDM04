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
//  final Completer<GoogleMapController> _controller =
//      Completer<GoogleMapController>();
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
//    final CameraPosition _puntoInicial = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),zoom: 14.4746,);
//    const CameraPosition _kGooglePlex = CameraPosition(
//      target: LatLng(37.42796133580664, -122.085749655962),
//      zoom: 14.4746,
//    );

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
//      body: Center(child: Text('${scan.valor}')),
      body: GoogleMap(
        mapType: MapType.normal,
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
