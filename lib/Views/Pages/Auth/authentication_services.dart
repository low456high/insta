import 'package:insta/Views/Pages/Auth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Home.dart';

class AuthenticationService {
  static var val;

  AuthenticationService({
    required this.ctx,
  });
  BuildContext ctx;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.hasData) {
          return LoginPage();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  logIn(email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Get.to(() => const HomePage());
      // Navigator.pushReplacement(
      //   ctx,
      //   MaterialPageRoute(
      //     builder: (context) => HomePage(),
      //   ),
      // );
    }).catchError(
      (FirebaseAuthEception) {
        showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(FirebaseAuthEception.toString()),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close')),
              ],
            );
          },
        );
      },
    );
    print(val);
    return val;
  }

  Future<UserCredential> signUp(email, password) {
    final userCre = FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => value)
        .catchError((FirebaseAuthEception) {
      showDialog(
          context: ctx,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(FirebaseAuthEception.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            );
          });
    });
    //print(val);
    return userCre;
  }

  // Future<UserCredential> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  // ) async {
  //   var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return user;
  // }
}
