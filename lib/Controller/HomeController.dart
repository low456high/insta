// ignore_for_file: file_names

import 'package:get/get.dart';

class HomeController extends GetxController {
  var SearchContainerHeight = 40.0.obs;
  var SearchContainerWidth = 40.0.obs;
  var isShowSearchContainer = false.obs;

  var count = 0.obs;
  void increment() => count++;

  // var texttest = "HELLO".obs;

  void changeContainerHeight() {
    if (isShowSearchContainer.isTrue) {
      SearchContainerHeight.value = 50.0;
      SearchContainerWidth.value = 50.0;
      isShowSearchContainer.value = false;
      print("Ture");
    } else {
      SearchContainerHeight.value = Get.height * 0.92;
      SearchContainerWidth.value = Get.width * 0.945;
      isShowSearchContainer.value = true;
      print("false");
    }
  }
}
