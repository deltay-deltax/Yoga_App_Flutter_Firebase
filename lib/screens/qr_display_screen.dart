// Create: lib/screens/qr_display_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplayScreen extends StatelessWidget {
  final String qrData;
  final String sessionType;

  QRDisplayScreen({required this.qrData, required this.sessionType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Booking QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session Booked Successfully!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Session: $sessionType',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),

            // QR Code Display
            QrImageView(
              data: qrData,
              size: 250.0,
              backgroundColor: Colors.white,
            ),

            SizedBox(height: 20),
            Text(
              'Show this QR code to gym staff',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
