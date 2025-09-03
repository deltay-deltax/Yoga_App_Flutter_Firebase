import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Using your preferred package
import '../services/firebase_service.dart';

class SessionBookingScreen extends StatelessWidget {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final List<String> sessions = ['Yoga', 'Gym', 'Zumba'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Session')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(sessions[index]),
              subtitle: Text('Duration: 60 mins | Price: ₹500'),
              trailing: ElevatedButton(
                onPressed: () async {
                  String qrCode =
                      await _firebaseService.bookSession(sessions[index]);
                  _showQRDialog(context, qrCode, sessions[index]);
                },
                child: Text('Book'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showQRDialog(BuildContext context, String qrCode, String sessionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Confirmed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$sessionType session booked successfully!'),
            SizedBox(height: 16),
            // Using QrImageView (updated widget name in qr_flutter 4.1.0)
            QrImageView(
              data: qrCode,
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
            SizedBox(height: 8),
            Text('Show this QR code for attendance'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
