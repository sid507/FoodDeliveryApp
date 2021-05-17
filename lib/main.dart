import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:food_delivery_app/user/Start.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';
import 'package:food_delivery_app/auth_screens/sign_up.dart';
import 'package:food_delivery_app/user/Menucard.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:food_delivery_app/widgets/SearchWidget.dart';
import 'package:food_delivery_app/backend/auth.dart';
import 'package:food_delivery_app/backend/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(FoodMain());
  });
}

class FoodMain extends StatelessWidget {
  final MaterialColor lightBlue = const MaterialColor(
    0xFFdee8ff,
    const <int, Color>{
      50: const Color(0xFFdee8ff),
      100: const Color(0xFFdee8ff),
      200: const Color(0xFFdee8ff),
      300: const Color(0xFFdee8ff),
      400: const Color(0xFFdee8ff),
      500: const Color(0xFFdee8ff),
      600: const Color(0xFFdee8ff),
      700: const Color(0xFFdee8ff),
      800: const Color(0xFFdee8ff),
      900: const Color(0xFFdee8ff),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/home',
      routes: {
        '/signup': (context) => SignUp(),
        '/signin': (context) => SignIn(),
        '/start': (context) => StartPage(),
        '/user': (context) => StartPage(),
        '/home': (context) => MenuOptionSide(
              automatic: true,
              address: "Searching ..",
            ),
      },
      // home: FirebaseAuth.instance.currentUser == null
      //     ? SignIn()
      //     : MenuOptionSide(automatic: true),
      home: FutureBuilder(
          future: Auth().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else {
              if (snapshot.hasData) {
                return MenuOptionSide(
                  automatic: true,
                  address: "Searching ..",
                );
                // return SearchWidget();
              } else {
                return SignIn();
              }
            }
          }),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
          hintColor: Color(0xFFd0cece)),
    );
  }
}
