// ignore_for_file: file_names

import 'package:insta/Views/Pages/CaptureFace.dart';
import 'package:insta/Views/Pages/Home.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Controller/SignUpController.dart';
import 'package:insta/Views/Widgets/ContainerButton.dart';
import 'package:insta/Views/Widgets/CustomTextFeild.dart';

import 'authentication_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final _cnfrmpass = TextEditingController();
  bool _isPasswordVisible1 = true;
  bool _isPasswordVisible2 = true;
  final _formKey = GlobalKey<FormState>();

  _changePassVisibility1() {
    if (_isPasswordVisible1 == true) {
      setState(() {
        _isPasswordVisible1 = false;
      });
    } else {
      setState(() {
        _isPasswordVisible1 = true;
      });
    }
  }

  _changePassVisibility2() {
    if (_isPasswordVisible2 == true) {
      setState(() {
        _isPasswordVisible2 = false;
      });
    } else {
      setState(() {
        _isPasswordVisible2 = true;
      });
    }
  }

  Future<void> getFCMToken(String uId) async {
    print("object");
    var token = '';
    FirebaseMessaging.instance.getToken().then(
      (value) {
        token = value!;
        ClientDatabase.addClient(
          fcmToken: token,
          mobile: _mobile.text,
          name: _name.text,
          uID: uId,
        ).then((value) => Get.to(() => const FaceCapture()));
        // print(value1.user!.uid);
        print(value);
      },
    );
  }

  _signup() async {
    if (_formKey.currentState!.validate()) {
      AuthenticationService(ctx: context)
          .signUp(
        _email.text.toString(),
        _password.text.toString(),
      )
          .then(
        (value1) {
          getFCMToken(value1.user!.uid);
        },
      );
      // var data = await SignUpController().signup(
      //     context,
      //     _name.text.toString(),
      //     _email.text.toString(),
      //     _mobile.text.toString(),
      //     _password.text.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      color: AppColor().PrimaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor().lightbg,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screen.height * 0.13,
                    ),
                    // Image.asset(
                    //   "assets/images/logo.jpeg",
                    //   height: 200,
                    //   fit: BoxFit.contain,
                    // ),
                    const Text(
                      "Signup",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _name,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Name",
                        istextarea: false,
                        obscure: false,
                        textcolor: AppColor().PrimaryColor,
                        title: "Name",
                        validator: (val) {
                          if (val.length == 0) {
                            return "Name must not be blank.";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _email,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Email",
                        istextarea: false,
                        obscure: false,
                        textcolor: AppColor().PrimaryColor,
                        title: "Email",
                        validator: (val) {
                          if (val.length == 0) {
                            return "Email must not be blank.";
                          } else if (!GetUtils.isEmail(val)) {
                            return "Please enter valid email.";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _mobile,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Mobile Number",
                        istextarea: false,
                        obscure: false,
                        textcolor: AppColor().PrimaryColor,
                        title: "Mobile Number",
                        validator: (val) {
                          if (val.length == 0) {
                            return "Mobile Number must not be blank.";
                          } else if (!GetUtils.isPhoneNumber(val)) {
                            return "Please enter valid mobile number.";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _password,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Password",
                        istextarea: false,
                        obscure: _isPasswordVisible1,
                        suffixIcon: InkWell(
                          onTap: () {
                            _changePassVisibility1();
                          },
                          child: _isPasswordVisible1
                              ? Icon(
                                  Icons.password,
                                  color: AppColor().PrimaryColor,
                                )
                              : Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: AppColor().PrimaryColor,
                                ),
                        ),
                        textcolor: AppColor().PrimaryColor,
                        title: "Password",
                        validator: (val) {
                          if (val.length == 0) {
                            return "Password must not be blank.";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _cnfrmpass,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Confirm Password",
                        istextarea: false,
                        obscure: _isPasswordVisible2,
                        suffixIcon: InkWell(
                          onTap: () {
                            _changePassVisibility2();
                          },
                          child: _isPasswordVisible2
                              ? Icon(
                                  Icons.password,
                                  color: AppColor().PrimaryColor,
                                )
                              : Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: AppColor().PrimaryColor,
                                ),
                        ),
                        textcolor: AppColor().PrimaryColor,
                        title: "Confirm Password",
                        validator: (val) {
                          if (val.length == 0) {
                            return "Confirm Password must not be blank.";
                          } else if (_password.text.toString() !=
                              val.toString()) {
                            return "Password doesn't match.";
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: _signup,
                      child: buttncontainer(
                        context: context,
                        color: AppColor().PrimaryColor,
                        height: 55.0,
                        isborder: false,
                        title: "Sign Up",
                        titlecolor: Colors.white,
                        width: screen.width,
                      ),
                    ),
                    SizedBox(
                      height: screen.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: AppColor().PrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
