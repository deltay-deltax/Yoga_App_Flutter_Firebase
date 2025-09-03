import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/services/notification_service.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';

class FirebaseService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rxn<UserModel> currentUser = Rxn<UserModel>();

  // Auth methods
  Future<bool> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel user = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      currentUser.value = user;
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(result.user!.uid).get();

      currentUser.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser.value = null;
  }

  // Booking methods
// In firebase_service.dart - add to bookSession method
  Future<String> bookSession(String sessionType) async {
    String qrCode =
        '${currentUser.value!.uid}_${DateTime.now().millisecondsSinceEpoch}';

    BookingModel booking = BookingModel(
      id: '',
      userId: currentUser.value!.uid,
      sessionType: sessionType,
      bookedAt: DateTime.now(),
      qrCode: qrCode,
    );

    await _firestore.collection('bookings').add(booking.toMap());

    // 🔥 ADD THIS: Automatic notification
    NotificationService.showLocalNotification('Booking Confirmed!',
        'Your $sessionType session has been booked successfully');

    return qrCode;
  }

  Future<List<BookingModel>> getUserBookings() async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('user_id', isEqualTo: currentUser.value!.uid)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAttendance(String qrCode) async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('qr_code', isEqualTo: qrCode)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({'attended': true});
    }
  }

  Future<void> updateMembership(bool active) async {
    await _firestore
        .collection('users')
        .doc(currentUser.value!.uid)
        .update({'membership_active': active});

    currentUser.value = UserModel(
      uid: currentUser.value!.uid,
      email: currentUser.value!.email,
      name: currentUser.value!.name,
      membershipActive: active,
    );
  }
}
