import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_service.dart';
import 'session_booking_screen.dart';
import 'qr_scanner_screen.dart';
import 'payment_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              _firebaseService.signOut();
              Get.back();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        final user = _firebaseService.currentUser.value;
        if (user == null) return CircularProgressIndicator();

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Name: ${user.name}'),
                      Text('Email: ${user.email}'),
                      Text(
                          'Membership: ${user.membershipActive ? "Active" : "Inactive"}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Daily Progress',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      LinearProgressIndicator(value: 0.7),
                      SizedBox(height: 8),
                      Text('70% of daily goal completed'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => SessionBookingScreen()),
                icon: Icon(Icons.book),
                label: Text('Book Session'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => QRScannerScreen()),
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scan QR for Attendance'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => PaymentScreen()),
                icon: Icon(Icons.payment),
                label: Text('Buy Membership'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? token = await FirebaseMessaging.instance.getToken();
                  print('FCM Token: $token');
                  Get.snackbar(
                      'FCM Token', 'Check console/debug output for token');
                },
                child: Text('Get FCM Token'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
