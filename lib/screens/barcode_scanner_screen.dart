import 'package:flutter/material.dart';
import 'package:kosher_ar/widgets/app_barcode_scanner_widget.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          AppBarcodeScannerWidget(
            resultCallback: (String code) {
              Navigator.pop(context, code);
            },
            label: 'buscar',
          ),
        ],
      ),
    );
  }
}
