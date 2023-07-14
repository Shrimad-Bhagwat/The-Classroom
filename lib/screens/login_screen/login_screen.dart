import 'package:flutter/material.dart';
import 'package:the_classroom/constants.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';

import '../../components/custom_buttons.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                          DefaultButton(
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  // go to next activity
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      HomeScreen.routeName, (route) => false);
                                }
                              },
                              titleB: 'SIGN IN'),
                          sizedBox,
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password',
                              textAlign: TextAlign.end,
                              style:
                                  TextStyle(fontSize: 16, color: kPrimaryColor),
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
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      textAlign: TextAlign.start,
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
        RegExp regExp = new RegExp(emailPattern);
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
