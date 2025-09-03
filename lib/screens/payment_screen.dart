import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatelessWidget {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy Membership')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Premium Membership',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('₹2999/month',
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                    SizedBox(height: 16),
                    Text('• Unlimited session bookings'),
                    Text('• Access to all facilities'),
                    Text('• Personal trainer consultation'),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await PaymentService.makePayment(2999.0);
                        if (success) {
                          await _firebaseService.updateMembership(true);
                          Get.snackbar(
                              'Success', 'Membership activated successfully!');
                          Get.back();
                        }
                      },
                      child: Text('Pay ₹2999'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
