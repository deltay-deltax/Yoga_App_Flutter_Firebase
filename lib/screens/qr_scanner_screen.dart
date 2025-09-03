import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/firebase_service.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        actions: [
          IconButton(
            onPressed: () => controller.toggleTorch(),
            icon: Icon(Icons.flash_on),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) async {
          final String? code = capture.barcodes.first.rawValue;
          if (code != null) {
            controller.stop();
            await _firebaseService.markAttendance(code);
            Get.snackbar(
              'Success',
              'Attendance marked successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.back();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
