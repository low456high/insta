import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:insta/Constant/Colors.dart';

class ProgressDialogue {
  final MyProgressController pressController = Get.put(MyProgressController());

  show(
    context, {
    loadingText,
  }) {
    pressController.changeValue(true);
    showProgressDialogue(context, loadingText);
  }

  hide(
    context,
  ) {
    if (pressController.readValue().value) {
      Navigator.pop(context);
      pressController.changeValue(false);
    }
  }
}

progressindecator(context) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(AppColor().PrimaryColor),
    ),
  );
}

showProgressDialogue(
  context,
  loadingText,
) {
  // var canPressOk=true;
  // blankScreen(context,loadingText);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          ProgressDialogue().hide(context);
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 150,
                              child: Lottie.asset(
                                  'assets/images/gameAnimation.json')),
                          Text(
                            loadingText ?? 'Default',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

class ProgressDialogue2 {
  final MyProgressController pressController = Get.put(MyProgressController());

  show(
    context, {
    loadingText,
  }) {
    pressController.changeValue(true);
    showProgressDialogue2(context, loadingText);
  }

  hide(
    context,
  ) {
    if (pressController.readValue().value) {
      Navigator.pop(context);
      pressController.changeValue(false);
    }
  }
}

showProgressDialogue2(
  context,
  loadingText,
) {
  // var canPressOk=true;
  // blankScreen(context,loadingText);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          ProgressDialogue().hide(context);
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor().PrimaryColor),
                      backgroundColor: Colors.white,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor().PrimaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  loadingText ?? 'Default Text',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    },
  );
}

class MyProgressController extends GetxController {
  var canPop = false.obs;

  readValue() {
    return canPop;
  }

  changeValue(val) {
    canPop = RxBool(val);
    print(canPop);
    // update();
  }
}
