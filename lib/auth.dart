import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // You can do something with the user object if needed
    } catch (e) {
      print("Error during login: $e");
    }
  }
}