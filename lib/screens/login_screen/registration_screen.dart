import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';

import '../../components/custom_buttons.dart';
import '../../components/toast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();


}

final FirebaseAuth _auth = FirebaseAuth.instance;
final _currentUser = _auth.currentUser;
final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

// Custom UID
String myemail = _currentUser!.email.toString();
String? customUID = myemail.split("@")[0];




void storeData(
    TextEditingController nameController,
    TextEditingController classController,
    TextEditingController rollController,
    TextEditingController regController,
    TextEditingController acadController,
    TextEditingController degreeController,
    TextEditingController courseController,
    TextEditingController specController,
    TextEditingController dobController,
    TextEditingController fathernameController,
    TextEditingController phoneController,
    TextEditingController emailController) {
  if (_currentUser != null) {
    databaseReference.child('users/${_currentUser!.uid}_$customUID/data').set({
      // == User ==
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'email': _currentUser!.email.toString(),
      'name': nameController.text,
      'class': classController.text,
      'roll_no': rollController.text,
      'reg_no': regController.text,
      'acad_year': acadController.text,
      'degree': degreeController.text,
      'course': courseController.text,
      'specialization': specController.text,
      'dob': dobController.text,
      'father_name': fathernameController.text,
      'phone': phoneController.text,
    });
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late bool _passwordVisible = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController regController = TextEditingController();
  TextEditingController acadController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController specController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController fathernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //    Registration
  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;
    final email = emailController.value.text;
    final password = passController.value.text;
    setState(() => _loading = true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": nameController.text,
        "email": email,
        "status": "Unavailable",
        "uid": _currentUser?.uid,
      });
      storeData(
          nameController,
          classController,
          rollController,
          regController,
          acadController,
          degreeController,
          courseController,
          specController,
          dobController,
          fathernameController,
          phoneController,
          emailController);

      showToastSuccess('Registration Success!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToastError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToastError('The account already exists for that email.');
      }
    } catch (e) {
      showToastError('An Error occurred $e');
    }
    if (this.mounted) {
      setState(() => _loading = false);
    }
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Registration"),
        ),
        body: Container(
          color: kTextWhiteColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      sizedBox,
                      customTextField(nameController, 'Name', 'John Snow'),
                      sizedBox,
                      customTextField(classController, 'Class', '1-A'),
                      sizedBox,
                      customTextField(rollController, 'Roll No.', '001'),
                      sizedBox,
                      customTextField(
                          regController, 'Registration No.', '20BCX10001'),
                      sizedBox,
                      customTextField(
                          acadController, 'Academic Year', '2020-2024'),
                      sizedBox,
                      customTextField(degreeController, 'Degree', 'B.Tech.'),
                      sizedBox,
                      customTextField(courseController, 'Course', 'CSE'),
                      sizedBox,
                      customTextField(
                          specController, 'Specialization', 'Gaming'),
                      sizedBox,
                      customTextField(dobController, 'D.O.B.', '01-01-2002'),
                      sizedBox,
                      customTextField(
                          fathernameController, "Father's Name", 'Ned Stark'),
                      sizedBox,
                      customTextField(phoneController, 'Phone', '998877655'),
                      sizedBox,
                      customTextField(
                          emailController, 'Email', 'john@gmail.com'),
                      sizedBox,
                      buildPasswordField(),
                      sizedBox,
                      CustomElevatedButton(
                        titleB: 'Register',
                        onPressed: () {
                          createUser();
                        },
                        isLoading: _loading,
                      ),
                      sizedBox,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      TextEditingController nameController, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: TextFormField(
        textAlign: TextAlign.start,
        controller: nameController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          hintText: hint,
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: TextFormField(
        controller: passController,
        obscureText: _passwordVisible,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.visiblePassword,
        style: const TextStyle(
          color: kTextBlackColor,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            iconSize: kDefaultPadding,
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          hintText: 'xxxxxx',
        ),
        validator: (value) {
          if (value!.length < 5) {
            return 'Password must be more than 6 characters';
          }
        },
      ),
    );
  }
}
