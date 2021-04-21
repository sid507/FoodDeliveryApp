import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/backend/database.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

class Auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  // otp verification during login
  Future<void> phoneNumberVerificationLogin(
      String phoneNumber, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (FirebaseAuthException authException) {
          AlertMessage()
              .showAlertDialog(context, "Error", authException.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                String errorText = "";
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Enter Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              errorText = "";
                            });
                          },
                        ),
                        errorText == ""
                            ? SizedBox()
                            : Text(
                                errorText,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          UserCredential userCredential = await _auth
                              .signInWithCredential(credential)
                              .catchError((error) {
                            setState(() {
                              errorText = error.message;
                            });
                          });
                          if (userCredential != null) {
                            setState(() {
                              errorText = "";
                            });
                            // User user = userCredential.user;
                            // we check if user belongs to Chef or Ninja
                            QuerySnapshot qs = await FirebaseFirestore.instance
                                .collection('User')
                                .where('phoneNum',
                                    isEqualTo: FirebaseAuth
                                        .instance.currentUser.phoneNumber)
                                .get();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/start', (route) => false);
                          }
                        },
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.sourceSansPro(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFFF785B)),
                        ),
                      )
                    ],
                  );
                });
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  // otp verification during register
  Future<void> phoneNumberVerificationRegister(String phoneNumber, String fname,
      String lname, String role, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: (FirebaseAuthException authException) {
          AlertMessage()
              .showAlertDialog(context, "Error", authException.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                String errorText = "";
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Enter Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        errorText == ""
                            ? SizedBox()
                            : Text(
                                errorText,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          UserCredential userCredential = await _auth
                              .signInWithCredential(credential)
                              .catchError((error) {
                            setState(() {
                              errorText =
                                  "Something went wrong! Make sure that you have entered correct code";
                            });
                          });
                          if (userCredential != null) {
                            setState(() {
                              errorText = "";
                            });
                            User user = userCredential.user;
                            // store details of new user
                            await Database().storeUserDetails(
                                user.uid, fname, lname, phoneNumber, role);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/start', (route) => false);
                          }
                        },
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.sourceSansPro(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFFF785B)),
                        ),
                      )
                    ],
                  );
                });
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  // get current logged in user
  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
