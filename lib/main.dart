import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:food_delivery_app/user/Start.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';
import 'package:food_delivery_app/auth_screens/sign_up.dart';
import 'package:food_delivery_app/user/Menucard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(FoodMain());
  });
}

class FoodMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => SignUp(),
        '/signin': (context) => SignIn(),
        '/start': (context) => StartPage(),
        '/user': (context) => StartPage(),
        '/home': (context) => MenuOptionSide(automatic: true),
      },
      // home: FirebaseAuth.instance.currentUser == null
      //     ? SignIn()
      //     : MenuOptionSide(automatic: true),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          hintColor: Color(0xFFd0cece)),
    );
  }
}
