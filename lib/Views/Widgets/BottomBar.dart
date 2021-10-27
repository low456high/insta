// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Constant/AppManager.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Views/Pages/Home.dart';
import 'package:insta/Views/Pages/Profile.dart';

Widget BottomToolBar({context, index, screen, name, username}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Container(
      height: 50,
      width: screen.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.white)),
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.off(() => const HomePage(),
                      transition: Transition.fadeIn);
                },
                child: Image.asset(
                  AppManager().HomeIcon,
                  height: 30,
                  color: index == 0 ? AppColor().PrimaryColor : Colors.black,
                ),
              ),
              Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                      color:
                          index == 0 ? AppColor().PrimaryColor : Colors.white,
                      shape: BoxShape.circle)),
            ],
          )),
          // Expanded(
          //     child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         Get.off(() => const OrderHistory(),
          //             transition: Transition.fadeIn);
          //       },
          //       child: Image.asset(
          //         AppManager().HistoryIcon,
          //         height: 30,
          //         color: index == 1 ? AppColor().PrimaryColor : Colors.black,
          //       ),
          //     ),
          //     Container(
          //         height: 5,
          //         width: 5,
          //         decoration: BoxDecoration(
          //             color:
          //                 index == 1 ? AppColor().PrimaryColor : Colors.white,
          //             shape: BoxShape.circle)),
          //   ],
          // )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => Profile());
                  },
                  child: Image.asset(
                    AppManager().ProfileIcon,
                    height: 30,
                    color: index == 2 ? AppColor().PrimaryColor : Colors.black,
                  ),
                ),
                Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color:
                            index == 2 ? AppColor().PrimaryColor : Colors.white,
                        shape: BoxShape.circle)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
