import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class UserAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);
  // final name;
  // ChefAppbar(this.name);
  Widget build(BuildContext context) {
    return AppBar(
        title: Text('Hello User',
            style: TextStyle(
                fontSize: 22,
                color: headingColor,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        // shadowColor: kMainColor,
        iconTheme: IconThemeData(color: headingColor),
        actions: <Widget>[
          //  Icon(Icons.person, size: 32),
          IconButton(
            padding: EdgeInsets.only(left: 5.0),
            icon: Icon(Icons.exit_to_app),
            iconSize: 30,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
              print("LogOut");
            },
          ),
        ]);
  }
}
