// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta/Constant/AppManager.dart';
import 'package:insta/Constant/Colors.dart';
import 'package:insta/Controller/HomeController.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'package:insta/Views/Widgets/BottomBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  //final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      color: AppColor().PrimaryColor,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("News Feed"),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColor().PrimaryColor,
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ClientDatabase.getPost(),
          builder: (context, snp) {
            if (snp.hasError) {
              return Center(
                child: Text("No Data is here"),
              );
            } else if (snp.hasData || snp.data != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: snp.data?.docs.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var post = snp.data?.docs[index].data()
                              as Map<String, dynamic>;
                          return Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  post["imageURL"],
                                  height: 200,
                                  width: screen.width,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  size: 35,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orangeAccent,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          // height: 50.0,
          child: BottomToolBar(
            context: context,
            index: 0,
            screen: screen,
          ),
        ),
      ),
    );
  }
}
