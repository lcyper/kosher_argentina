import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

late Function(String result) _resultCallback;

///
/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  ///
  ///
  AppBarcodeScannerWidget({
    Key? key,
    Function(String result)? resultCallback,
    String label = 'Single number',
  }) : super(key: key) {
    _resultCallback = resultCallback ?? (String result) {};
  }

  @override
  _AppBarcodeState createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return _BarcodePermissionWidget();
  }
}

class _BarcodePermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BarcodePermissionWidgetState();
  }
}

class _BarcodePermissionWidgetState extends State<_BarcodePermissionWidget> {
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();
  }

  void _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _requestMobilePermission();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    } else {
      setState(() {
        _isGranted = true;
      });
    }

    return Expanded(
      child: _isGranted
          ? _BarcodeScannerWidget()
          : Center(
              child: OutlinedButton(
                onPressed: () {
                  _requestMobilePermission();
                },
                child: const Text("Request Mobile Permission"),
              ),
            ),
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      _resultCallback(result);
    }, scannerViewCreated: () {
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(const Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _getScanWidgetByPlatform(),
        )
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
