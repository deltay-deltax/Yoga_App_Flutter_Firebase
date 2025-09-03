import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
        contentPadding: EdgeInsets.all(20),
        content: Container(
          width: 280, // Fixed width
          height: 320, // Fixed height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$sessionType session booked successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrCode,
                  version: QrVersions.auto,
                  gapless: false,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Show this QR code for attendance',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
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
