import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_delivery_app/user/Menucard.dart';
import 'package:food_delivery_app/user/UserHome.dart';

class AppDrawer extends StatelessWidget {
  bool automatic;
  AppDrawer({Key key, @required this.automatic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          Divider(),
          _createDrawerItem(Icons.home, 'Home', 'home', context),
          Divider(),
          _createDrawerItem(
              Icons.add_shopping_cart, 'My Orders', 'home', context),
          Divider(),
          _createDrawerItem(
              Icons.add_shopping_cart_sharp, 'My Account', 'home', context),
          Divider(),
          _createDrawerItem(Icons.help, 'Help', 'home', context),
          Divider(),
          _createDrawerItem(Icons.login, 'Log Out', 'signin', context),
          ListTile(
            title: Text('Version 0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/drawer_header_background.png'),
        ),
      ),
      child: Container(),
      // child: Stack(
      //   children: <Widget>[
      //     Positioned(
      //         bottom: 12.0,
      //         left: 16.0,
      //         child: Text("Food Delivery App",
      //             style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 20.0,
      //                 fontWeight: FontWeight.w500))),
      //   ],
      // ),
    );
  }

  Widget _createDrawerItem(
      IconData icon, String text, String link, BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: () {
        if (link == 'signin') {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, '/$link');
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuOptionSide(automatic: automatic),
            ),
          );
        }
      },
    );
  }
}
