// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta/Constant/Colors.dart';

class AlertToast {
  showtoast(msg) {
    return Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor().PrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
