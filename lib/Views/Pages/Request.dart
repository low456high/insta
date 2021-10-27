import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/Views/Pages/client_database.dart';
import 'client_database.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: ClientDatabase.getClientRequest(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snp) {
            if (snp.hasError) {
              return Center(
                child: Text("No Data is here"),
              );
            } else if (snp.hasData || snp.data != null) {
              return ListView.builder(
                  itemCount: snp.data?.docs.length,
                  itemBuilder: (context, index) {
                    var request =
                        snp.data?.docs[index].data() as Map<String, dynamic>;
                    var name = request['posterName'];
                    return request["status"] == "Pending"
                        ? Card(
                            elevation: 10,
                            color: Colors.amberAccent[200],
                            child: Column(
                              children: [
                                Text(
                                  "Request From $name",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                Image.network(
                                  request["imageURL"],
                                  fit: BoxFit.contain,
                                  height: 250,
                                  width: 250,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Clients')
                                            .doc(request["posterID"])
                                            .collection("Posts")
                                            .doc(request["postID"])
                                            .get()
                                            .then(
                                          (value) {
                                            if (value['val'] == 1) {
                                              ClientDatabase.updateValInPost(
                                                mainid: request["posterID"],
                                                postID: request["postID"],
                                                val: 0,
                                              );
                                              ClientDatabase
                                                  .updateImageURLinPost(
                                                mainid: request["posterID"],
                                                postid: request["postID"],
                                                status: "Approved",
                                              );
                                              ClientDatabase.deleteRequest(
                                                uID: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                reqID: snp.data!.docs[index].id,
                                              );
                                              ClientDatabase.addPost(
                                                imageURL: request["imageURL"],
                                              );
                                            } else if (value['val'] > 1) {
                                              ClientDatabase.updateValInPost(
                                                mainid: request["posterID"],
                                                postID: request["postID"],
                                                val: value['val'] - 1,
                                              );
                                              ClientDatabase.deleteRequest(
                                                uID: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                reqID: snp.data!.docs[index].id,
                                              );
                                              // ClientDatabase
                                              //     .updateStatusinRequest(
                                              //   mainid: FirebaseAuth
                                              //       .instance.currentUser!.uid,
                                              //   postid:
                                              //       snp.data!.docs[index].id,
                                              //   status: "Approve",
                                              // );
                                            }
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Approved",
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ClientDatabase.updateImageURLinPost(
                                          mainid: request["posterID"],
                                          postid: request["postID"],
                                          status: "Disapprove",
                                        );
                                        ClientDatabase.deleteRequest(
                                          uID: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          reqID: snp.data!.docs[index].id,
                                        );
                                        // ClientDatabase
                                        //     .updateStatusinRequest(
                                        //   mainid: FirebaseAuth
                                        //       .instance.currentUser!.uid,
                                        //   postid:
                                        //       snp.data!.docs[index].id,
                                        //   status: "Approve",
                                        // );
                                      },
                                      child: Text(
                                        "Disapprov",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : SizedBox();
                  });
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orangeAccent,
                ),
              ),
            );
          }),
    );
  }
}
