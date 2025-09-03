import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firebase_service.dart';
import 'signup_screen.dart';
import '../dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseService _firebaseService = Get.put(FirebaseService());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                bool success = await _firebaseService.signIn(
                    emailController.text, passwordController.text);
                if (success) {
                  Get.off(() => DashboardScreen());
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Get.to(() => SignupScreen()),
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
