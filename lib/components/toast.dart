import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Toast Messages
void showToastError(String message) => Fluttertoast.showToast(
  msg: message,
  backgroundColor: Colors.red,
);

void showToastSuccess(String message) => Fluttertoast.showToast(
  msg: message,
  backgroundColor: Colors.green,
);