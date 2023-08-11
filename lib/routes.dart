import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:the_classroom/screens/chat_screen/chat_screen.dart';
import 'package:the_classroom/screens/home_screen/home_screen.dart';
import 'package:the_classroom/screens/login_screen/login_screen.dart';
import 'package:the_classroom/screens/splash_screen/splash_screen.dart';


Map<String,WidgetBuilder> routes = {
  SplashScreen.routeName : (context) => const SplashScreen(),
  LoginScreen.routeName : (context) => const LoginScreen(),
  HomeScreen.routeName : (context) => const HomeScreen(),
  ChatScreen.routeName : (context) => const ChatScreen(),
};