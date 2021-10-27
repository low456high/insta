import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("Clients");
FirebaseStorage _storage = FirebaseStorage.instance;

class ClientDatabase {
  static String? userID;

  static Future<void> updateImageURLinPost({
    required String mainid,
    required String postid,
    required String status,
  }) async {
    DocumentReference collectionRef =
        _mainCollection.doc(mainid).collection("Posts").doc(postid);
    await collectionRef
        .update({
          'status': status,
        })
        .then((value) => print("Image URL is added"))
        .catchError((error) => print("Failed to add image URL: $error"));
  }

  static Future<void> updateStatusinRequest({
    required String mainid,
    required String postid,
    required String status,
  }) async {
    DocumentReference collectionRef =
        _mainCollection.doc(mainid).collection("Request").doc(postid);
    await collectionRef
        .update({
          'status': status,
        })
        .then((value) => print("Status is updated"))
        .catchError((error) => print("Failed to update status: $error"));
  }

  static Future<void> updateImageURL({
    required String mainid,
    required String imageURL,
  }) async {
    DocumentReference collectionRef = _mainCollection.doc(mainid);
    await collectionRef
        .update({
          'imageURL': imageURL,
        })
        .then((value) => print("Image URL is added"))
        .catchError((error) => print("Failed to add image URL: $error"));
  }

  static Future<void> updateValInPost({
    required String mainid,
    required String postID,
    required int val,
  }) async {
    DocumentReference collectionRef =
        _mainCollection.doc(mainid).collection("Posts").doc(postID);
    await collectionRef
        .update({
          'val': val,
        })
        .then((value) => print("Val is updated"))
        .catchError((error) => print("Failed to update val: $error"));
  }

  static Future<void> deleteAccountInClient({
    required String mainid,
  }) async {
    DocumentReference collectionRef = _mainCollection.doc(mainid);
    await collectionRef
        .delete()
        .then((value) => print("User Account Deleted"))
        .catchError((error) => print("Failed to Delete User Account: $error"));
  }

  static Future<void> addCheckForPost({
    required String uID,
    required String postID,
    required String val,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      "val": val,
    };
    await _mainCollection
        .doc(uID)
        .collection("Posts")
        .doc(postID)
        .collection("Check")
        .add(data)
        .whenComplete(() => print("Request is saved"))
        .catchError((e) => print(e));
  }

  static Future<void> addRequest({
    required String uID,
    required String posterID,
    required String postID,
    String status = "Pending",
    required String imageURL,
    required String name,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      "posterID": posterID,
      "postID": postID,
      "status": status,
      "imageURL": imageURL,
      "posterName": name
    };
    await _mainCollection
        .doc(uID)
        .collection("Request")
        .add(data)
        .whenComplete(() => print("Request is saved"))
        .catchError((e) => print(e));
  }

  static Future<void> addPost({
    required String imageURL,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      "imageURL": imageURL,
    };
    await _firestore
        .collection("Post")
        .add(data)
        .whenComplete(() => print("Request is saved"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteRequest({
    required String uID,
    required String reqID,
  }) async {
    Map<String, dynamic> data = <String, dynamic>{};
    await _mainCollection
        .doc(uID)
        .collection("Request")
        .doc(reqID)
        .delete()
        .whenComplete(() => print("Request is deleted"))
        .catchError((e) => print(e));
  }

  static Future<void> addClient({
    required String uID,
    required String name,
    required String mobile,
    required String fcmToken,
    String imageURL = "",
  }) async {
    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "mobile": mobile,
      "fcmToken": fcmToken,
      "imageURL": imageURL,
    };
    await _mainCollection
        .doc(uID)
        .set(data)
        .whenComplete(() => print("Data is saved"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> getPost() {
    return _firestore.collection("Post").snapshots();
  }

  static Stream<QuerySnapshot> getDataOfClients() {
    return _mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> getTransactionHistoryOfClients(String id) {
    return _mainCollection.doc(id).collection("TransactionHistory").snapshots();
  }

  static Stream<QuerySnapshot> getComplaintsOfClients(String id) {
    return _mainCollection.doc(id).collection("Complaints").snapshots();
  }

  static Stream<QuerySnapshot> getClients() {
    return _mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> getClientPosts(String id) {
    return _mainCollection.doc(id).collection("Posts").snapshots();
  }

  static Stream<QuerySnapshot> getClientRequest(String id) {
    return _mainCollection.doc(id).collection("Request").snapshots();
  }

  static Future addCPostInClient({
    required String userID,
    required String imageURL,
    String status = "Pending",
    int val = 0,
  }) async {
    CollectionReference collectionRef =
        _mainCollection.doc(userID).collection("Posts");

    Map<String, dynamic> data = <String, dynamic>{
      "status": status,
      "imageURL": imageURL,
      "val": val,
    };
    await collectionRef.add(data).whenComplete(() {
      print("Data is saved");
    }).catchError((e) => print(e));
    return collectionRef.id;
  }
}
