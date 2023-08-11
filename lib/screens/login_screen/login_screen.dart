import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_snackbar/simple_snackbar.dart';
import 'package:the_classroom/components/theme.dart';
import 'package:the_classroom/constants.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';

import '../../auth.dart';
import '../../components/custom_buttons.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _formKey = GlobalKey<FormState>();
  // final bool _isLogin = true;
  // bool _loading = false;
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // bool _authChecked = false;
  //
  // void _checkAuthStatus() async {
  //   if (_authChecked) return;
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   auth.authStateChanges().listen((User? user) {
  //     if (user != null) {
  //       // User is logged in, navigate to HomeScreen
  //       Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
  //     } else {
  //       // User is not logged in, navigate to LoginScreen
  //       Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
  //     }
  //   });
  //   setState(() {
  //     _authChecked = true; // Update the flag after the check
  //   });
  // }
  //
  // handleSubmit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   final email = _emailController.value.text;
  //   final password = _passwordController.value.text;
  //
  //   setState(() => _loading = true);
  //
  //   //Check if is login or register
  //   if (_isLogin) {
  //     await Auth().signInWithEmailAndPassword(email, password);
  //     _checkAuthStatus();
  //     showInSnackBar('Login Success! \n$email $password');
  //   } else {
  //     await Auth().registerWithEmailAndPassword(email, password);
  //     _checkAuthStatus();
  //     showInSnackBar('Register Success! \n$email $password');
  //
  //   }
  //
  //   setState(() => _loading = false);
  // }
  // void showInSnackBar(String value) {
  //   final snackBar = simpleSnackBar(
  //     //required
  //       buildContext: context,
  //       //required
  //       messageText: value,
  //       backgroundColor: Colors.white,
  //       displayDismiss: false,
  //       textColor: Colors.black,
  //       snackBarType: SnackBarType.info);
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
    // _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Classroom Auth',
      home: StreamBuilder<User?>(
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
  final bool _isLogin = true;
  bool _loading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _authChecked = false;

  void _checkAuthStatus() async {
    if (_authChecked) return;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in, navigate to HomeScreen
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (route) => false);
      } else {
        // User is not logged in, navigate to LoginScreen
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      }
    });
    setState(() {
      _authChecked = true; // Update the flag after the check
    });
  }

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() => _loading = true);

    //Check if is login or register
    if (_isLogin) {
      await Auth().signInWithEmailAndPassword(email, password);
      // _checkAuthStatus();
      showInSnackBar('Login Success! \n$email $password');
    } else {
      await Auth().registerWithEmailAndPassword(email, password);
      // _checkAuthStatus();
      showInSnackBar('Register Success! \n$email $password');
    }

    setState(() => _loading = false);
  }

  void showInSnackBar(String value) {
    final snackBar = simpleSnackBar(
        //required
        buildContext: context,
        //required
        messageText: value,
        backgroundColor: Colors.white,
        displayDismiss: false,
        textColor: Colors.black,
        snackBarType: SnackBarType.info);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(context),
        home: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
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
                            style: Theme.of(context).textTheme.bodyLarge,
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
                  height: MediaQuery.of(context).size.height / 2.3,
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
                              ElevatedButton(
                                onPressed: () => handleSubmit(),
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(_isLogin ? 'Login' : 'Register'),
                              ),
                              // DefaultButton(
                              //     onPress: () {
                              //       handleSubmit();
                              //
                              //       // if (_formKey.currentState!.validate()) {
                              //       //   // go to next activity
                              //       //   Navigator.pushNamedAndRemoveUntil(context,
                              //       //       HomeScreen.routeName, (route) => false);
                              //       }
                              //     },
                              //     titleB: 'SIGN IN'),
                              sizedBox,
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot Password',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 16, color: kPrimaryColor),
                                ),
                              )
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
        ));
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
          )
          // hintText: 'x x x x x x x x',
          ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Password must be more than 6 characters';
        }
      },
    );
  }
}
