import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_classroom/extras/constants.dart';

// Toast Messages
void showToastError(String message) => Fluttertoast.showToast(
  msg: message,
  backgroundColor: Colors.red,
);

void showToastSuccess(String message) => Fluttertoast.showToast(
  msg: message,
  backgroundColor: Colors.green,
);

void showToast(String message) => Fluttertoast.showToast(
  msg: message,
  backgroundColor: kPrimaryColor,
);