// ignore_for_file: file_names

import 'package:insta/Helper/ApiManager.dart';

App app = App();

class SignUpController {
  signup(context, name, email, mobile, pass) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "pass": pass,
    };

    var data = await app.api("user-signup", body, context);
    print(data.toString());
  }
}
