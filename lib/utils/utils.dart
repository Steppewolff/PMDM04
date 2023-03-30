import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scan_model.dart';

//Future<void> _launchUrl(BuildContext context, ScanModel scan) async {
void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;
  if (scan.tipus == 'http') {
    if (!await launch(url)) throw 'Could not launch $url';
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
