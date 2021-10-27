// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta/Views/Pages/Auth/Login.dart';

class AppManager extends GetxController {
  String get appversion => "0.0.1";

  String get smileimoji => "😊";
  String get hiemijo => "👋";
  String get thumbemoji => "🤙";
  String get HomeIcon => "assets/images/Home.png";
  String get HistoryIcon => "assets/images/History.png";
  String get ProfileIcon => "assets/images/Profile.png";
  String get SearchIcon => "assets/images/Search.png";
  String get LocationIcon => "assets/images/Location.png";
  String get LogoutIcon => "assets/images/Logout.png";
  String get UserIcon => "assets/images/User.png";
  String get BackIcon => "assets/images/Back.png";

  final box = GetStorage();

  Map get getUserData => box.read('UserData') ?? {};
  String get getUserid =>
      getUserData.isEmpty ? '' : getUserData['id'].toString();
  String get getUserFullName => getUserData.isEmpty ? '' : getUserData['name'];
  String get getUserEmail => getUserData.isEmpty ? '' : getUserData['email'];
  String get getUserMobile => getUserData.isEmpty ? '' : getUserData['mobile'];
  String get getUserImage => getUserData.isEmpty ? '' : getUserData['img'];

  SaveUSerData(Map userdata) async {
    await box.write('UserData', userdata);
  }

  removeUserData() async {
    await box.remove('UserData');
    Get.offAll(() => LoginPage());
  }
}
