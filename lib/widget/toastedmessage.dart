import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastedmessage({
  required String msg,
  required Color backgroundColor,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 8,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 20.0);
}
