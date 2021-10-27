// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Controller/HomeController.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // ignore: non_constant_identifier_names
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Obx(() => Text(_homeController.count.toString())),
          ElevatedButton(
            child: Text('Next Route'),
            onPressed: () {
              _homeController.increment();
              // Get.to(Second());
            },
          ),
        ],
      ),
    );
  }
}
