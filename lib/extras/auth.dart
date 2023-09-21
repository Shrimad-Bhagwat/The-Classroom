import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword(
      BuildContext context, String email, String password) async {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

}
