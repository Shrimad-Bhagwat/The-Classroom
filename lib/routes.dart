import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:the_classroom/screens/assignment_screen/assignment_screen.dart';
import 'package:the_classroom/screens/chat_screen/chat_screen.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';
import 'package:the_classroom/screens/my_profile/my_profile.dart';
import 'package:the_classroom/screens/result_screen/result_screen.dart';
import 'package:the_classroom/screens/splash_screen/splash_screen.dart';


Map<String,WidgetBuilder> routes = {
  SplashScreen.routeName : (context) => const SplashScreen(),
  LoginScreen.routeName : (context) => const LoginScreen(),
  HomeScreen.routeName : (context) => const HomeScreen(),
  ChatScreen.routeName : (context) => const ChatScreen(),
  MyProfileScreen.routeName : (context) => const MyProfileScreen(),
  AssignmentScreen.routeName : (context) => const AssignmentScreen(),
  ResultScreen.routeName : (context) => const ResultScreen(),
};