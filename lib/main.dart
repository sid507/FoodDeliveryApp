import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Start.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';
import 'package:food_delivery_app/user/UserHome.dart';
import 'package:food_delivery_app/user/Menucard.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FoodMain());
}

class FoodMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => HomePage(),
        '/': (context) => SignIn(),
        '/user': (context) => StartPage(),
        '/home': (context) => MenuOptionSide(),
        '/signin': (context) => SignIn(),
      },
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          hintColor: Color(0xFFd0cece)),
    );
  }
}
