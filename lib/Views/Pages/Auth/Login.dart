// ignore_for_file: file_names, unused_field

import 'package:insta/Views/Pages/Auth/authentication_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Controller/LoginController.dart';
import 'package:insta/Views/Pages/Auth/SignUp.dart';
import 'package:insta/Views/Pages/Home.dart';
import 'package:insta/Views/Pages/TestPage.dart';
import 'package:insta/Views/Widgets/ContainerButton.dart';
import 'package:insta/Views/Widgets/CustomTextFeild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  // ignore: prefer_final_fields
  bool _isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();

  final LoginController _loginController = Get.put(LoginController());

  _changePassVisibility() {
    if (_isPasswordVisible == true) {
      setState(() {
        _isPasswordVisible = false;
      });
    } else {
      setState(() {
        _isPasswordVisible = true;
      });
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
                      height: screen.height * 0.3,
                    ),
                    // Image.asset(
                    //   "assets/images/logo.jpeg",
                    //   height: 200,
                    //   fit: BoxFit.contain,
                    // ),
                    const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 30,
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
                      height: 20,
                    ),
                    MyCustomTextField(
                        context: context,
                        controller: _pass,
                        bordercolor: AppColor().PrimaryColor,
                        hinttext: "Password",
                        istextarea: false,
                        obscure: _isPasswordVisible,
                        suffixIcon: InkWell(
                          onTap: () {
                            _changePassVisibility();
                          },
                          child: _isPasswordVisible
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
                      height: 30,
                    ),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            AuthenticationService(
                              ctx: context,
                            ).logIn(
                              _email.text,
                              _pass.text,
                            );
                            // _loginController.login(
                            //     _email.text, _pass.text, context);
                            // Get.to(() => const HomePage());
                          }
                        },
                        child: buttncontainer(
                          context: context,
                          color: AppColor().PrimaryColor,
                          height: 55.0,
                          isborder: false,
                          title: _loginController.visible.isTrue
                              ? "Wait..."
                              : "Login",
                          titlecolor: Colors.white,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screen.height * 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        InkWell(
                          onTap: () {
                            Get.to(() => const SignUp());
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: AppColor().PrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
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
