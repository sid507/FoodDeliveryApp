import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/backend/auth.dart';

class Database {
  static final firestore = FirebaseFirestore.instance;

  Future<bool> userExists(BuildContext context, String phoneNum) async {
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

  storeUserDetails(String uid, String fname, String lname, String phoneNum,
      String role) async {
    return FirebaseFirestore.instance.collection('User').doc(uid).set({
      'fname': fname,
      'lname': lname,
      'phoneNum': phoneNum,
    });
  }
}
