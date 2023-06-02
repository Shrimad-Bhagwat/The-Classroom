import 'package:flutter/material.dart';
import 'package:the_classroom/constants.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
    });
    return Scaffold(
        body: Center(
          child:   Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/classroom_icon.png',width: 300,height: 300,),
              Text('The Classroom',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: kTextWhiteColor,
                fontSize: 40.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5
              ),),
            ],

          ),
        ),
    );
  }
}
