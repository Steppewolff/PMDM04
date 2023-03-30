import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/utils/utils.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../models/scan_model.dart';
import '../providers/db_provider.dart';
import '../providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {
        const COLOR_CODE = '#3D8BEF';
        const CANCEL_BUTTON_TEXT = 'Cancelar';
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            COLOR_CODE, CANCEL_BUTTON_TEXT, false, ScanMode.QR);
        print(barcodeScanRes);
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        ScanModel nouScan = ScanModel(valor: barcodeScanRes);
        scanListProvider.nouScan(barcodeScanRes);
        launchURL(context, nouScan);
      },
    );
  }
}
