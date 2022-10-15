import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> toast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: Color.fromARGB(255, 96, 252, 6),
      textColor: Color.fromARGB(255, 10, 10, 10),
      fontSize: 15.0);
}

Future<bool?> toast1(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: Color.fromARGB(255, 252, 6, 6),
      textColor: Color.fromARGB(255, 255, 255, 255),
      fontSize: 15.0);
}
