import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.login, text: 'Sign In'),
          Divider(),
          _createDrawerItem(icon: Icons.home, text: 'Home'),
          Divider(),
          _createDrawerItem(icon: Icons.add_shopping_cart, text: 'My Orders'),
          Divider(),
          _createDrawerItem(
            icon: Icons.add_shopping_cart_sharp,
            text: 'My Account',
          ),
          Divider(),
          _createDrawerItem(icon: Icons.help, text: 'Help'),
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
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Food Delivery App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
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
      onTap: onTap,
    );
  }
}
