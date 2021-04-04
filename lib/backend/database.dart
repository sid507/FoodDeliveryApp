// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<bool> userExists(String phoneNum) async {
    QuerySnapshot user;
    user = await FirebaseFirestore.instance
        .collection('User')
        .where('phoneNum', isEqualTo: phoneNum)
        .get();
    if (user.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<DocumentReference> storeUserDetails(
      String fname, String lname, String phoneNum, String role) async {
    return FirebaseFirestore.instance
        .collection(role)
        .add({'fname': fname, 'lname': lname, 'phoneNum': phoneNum});
  }
}
