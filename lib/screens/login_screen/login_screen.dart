import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_snackbar/simple_snackbar.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/extras/constants.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';
import 'package:the_classroom/screens/login_screen/registration_screen.dart';
import '../../extras/auth.dart';
import '../../components/custom_buttons.dart';
import '../../components/toast.dart';


late bool _passwordVisible;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Classroom Auth',
      home: StreamBuilder<User?>(
        // Check if User is Logged in
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreenPage();
          }
        },
      ),
    );
  }
}

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //    Registration
  Future<void> createUser() async {
    // if (!_formKey.currentState!.validate()) return;
    // final email = _emailController.value.text;
    // final password = _passwordController.value.text;
    // setState(() => _loading = true);
    // try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   // try {
    //   await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
    //     "email": email,
    //     "status": "Unavailable",
    //   });
    //   //   // showToastSuccess('Done');
    //   // } catch(e){debugPrint(e.toString());showToastError(e.toString());}
    //
    //   showToastSuccess('Registration Success!');
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     showToastError('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     showToastError('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   showToastError('An Error occurred $e');
    // }
    // if (this.mounted) {
    //   setState(() => _loading = false);
    // }
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  //    Login
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    setState(() => _loading = true);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // try {
      //   await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
      //     "email": email,
      //     "status": "Unavailable",
      //   });
      //   // showToastSuccess('Done');
      // } catch(e){debugPrint(e.toString());showToastError(e.toString());}
      showToastSuccess('Login Success!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToastError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToastError('Wrong password provided for that user.');
      }
    } catch (e) {
      showToastError('An Error occurred $e');
    }
    setState(() => _loading = false);
  }
  
  //    Forgot Password
  Future<void> resetPassword() async {
    final email = _emailController.value.text;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
      showToastSuccess('Password Reset Email sent.');
    } catch (e) {
      if(email=='') {
        showToastError('Enter email address!');
      } else {
        showToastError('An error occurred ${e.toString()}');
      }
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context),
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: _scaffoldKey,
          body: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/classroom_icon.png',
                      height: 200,
                      width: 200,
                    ),
                    kHalfSizedBox,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: kTextWhiteColor,
                                    fontSize: 30.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        sizedBox,
                        Text(
                          'Welcome User',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: kTextWhiteColor,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.1,
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(kDefaultPadding * 3)),
                  color: kOtherColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            sizedBox,
                            buildEmailField(),
                            sizedBox,
                            buildPasswordField(),
                            sizedBox,
                            CustomElevatedButton(
                              titleB: 'Login',
                              onPressed: loginUser,
                              isLoading: _loading,
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        createUser();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: kPrimaryColor,
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {resetPassword();},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: kPrimaryColor,
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      textAlign: TextAlign.start,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: kTextBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        labelText: 'Email Address',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        hintText: 'john.wick2020@vitbhopal.ac.in',
      ),
      validator: (value) {
        RegExp regExp = RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please enter all the details';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
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
    );
  }
}
