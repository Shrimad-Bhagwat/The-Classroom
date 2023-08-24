import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../components/toast.dart';
import '../my_profile.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final _currentUser = auth.currentUser;

Future<Map> fetchData() async {
  Map<dynamic, dynamic> data={};
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  if (_currentUser != null) {
    final snapshot =
    await ref.child('users/${_currentUser!.uid}_$customUID/data').get();
    if (snapshot.exists) {
        data['name'] = snapshot.child('name').value.toString();
        data['class'] = snapshot.child('class').value.toString();
        data['roll_no'] = snapshot.child('roll_no').value.toString();
        data['reg_no'] = snapshot.child('reg_no').value.toString();
        data['acad_year'] = snapshot.child('acad_year').value.toString();
        data['degree'] = snapshot.child('degree').value.toString();
        data['course'] = snapshot.child('course').value.toString();
        data['specialization'] =
            snapshot.child('specialization').value.toString();
        data['dob'] = snapshot.child('dob').value.toString();
        data['father_name'] = snapshot.child("father_name").value.toString();
        data['phone'] = snapshot.child('phone').value.toString();
        data['email'] = snapshot.child('email').value.toString();
    } else {
      showToastError('No data available!');

    }
  } else {
    showToastError('User not found!');

  }
  return data;
}
