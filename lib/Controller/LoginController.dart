// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:insta/Constant/AppManager.dart';
import 'package:insta/Helper/ApiManager.dart';
import 'package:insta/Helper/ToastHelper.dart';
import 'package:insta/Views/Pages/Home.dart';

App app = App();

class LoginController extends GetxController {
  var visible = false.obs;

  login(email, pass, context) async {
    visible.value = true;
    Map<String, dynamic> body = {
      "email": email.toString(),
      "pass": pass.toString(),
    };
    var data = await app.api("driver-login", body, context);
    if (data['success'] == "error") {
      visible.value = false;
      AlertToast().showtoast("Invalid User");
    } else if (data['success'] == "success") {
      visible.value = false;
      await AppManager().SaveUSerData(data['data']);
      Get.offAll(() => const HomePage());
    }
    // print(data.toString());
  }
}
