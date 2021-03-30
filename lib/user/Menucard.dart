// import 'dart:ffi';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:food_delivery_app/user/AllEatOption.dart';
import 'package:food_delivery_app/user/Cart.dart';
import 'package:food_delivery_app/user/Eating_opti.dart';
import 'package:food_delivery_app/user/SignInPage.dart';
import 'package:food_delivery_app/user/Utils.dart';
import 'UserHome.dart';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/widgets/drawer.dart';

class MenuOptionSide extends StatefulWidget {
  @override
  _MenuOptionSideState createState() => _MenuOptionSideState();
}

class _MenuOptionSideState extends State<MenuOptionSide> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    this._children = [HomePage(), MyApp(), FoodOrderPage(), SignInPage()];
    print(this._children);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: colorScheme.surface,
          selectedItemColor: Helper().button,
          unselectedItemColor: colorScheme.onSurface.withOpacity(.30),
          selectedLabelStyle: textTheme.caption,
          unselectedLabelStyle: textTheme.caption,
          onTap: (value) {
            // Respond to item press.
            setState(() => {_currentIndex = value, print(_currentIndex)});
          },
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(
              label: "Order",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "Cart",
              icon: Icon(Icons.shopping_cart_outlined),
            ),
            BottomNavigationBarItem(
              label: "My Account",
              icon: Icon(Icons.person_outline),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: Colors.red,
        //     child: Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       setState(() {
        //         drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
        //             ? FSBStatus.FSB_CLOSE
        //             : FSBStatus.FSB_OPEN;
        //       });
        //     }),
      ),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    textTheme: _buildShrineTextTheme(base.textTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
