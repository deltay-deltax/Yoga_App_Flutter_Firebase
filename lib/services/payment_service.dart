import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _stripeSecretKey = "your key";
  // Your Stripe secret key

  static Future<bool> makePayment(double amount) async {
    try {
      // Create payment intent
      final paymentIntentData = await _createPaymentIntent(amount);

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Fitness App',
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> _createPaymentIntent(
      double amount) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $_stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'amount': (amount * 100).toInt().toString(),
        'currency': 'inr',
      },
    );
    return json.decode(response.body);
  }
}
