// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Constant/AppManager.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Views/Pages/Auth/Login.dart';
import 'package:insta/Views/Pages/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      ckecklogin();
    });
  }

  ckecklogin() async {
    // var username = AppManager().getUserFullName.toString();
    // if (username.isEmpty || username.toString() == "") {
    //   Get.to(() => LoginPage());
    // } else {
    //   Get.to(() => HomePage());
    // }

    Get.to(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor().PrimaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor().lightbg,
          body: Padding(
            padding: EdgeInsets.only(bottom: 40, top: Get.height * 0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: const Text("FaceCapture",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                // Center(
                //     child: Image.asset(
                //   "assets/images/logo.jpeg",
                //   height: 220,
                //   width: 220,
                //   fit: BoxFit.contain,
                // )),

                // Text("For Drivers",
                // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
