import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/user/EatDaily.dart';
import 'package:food_delivery_app/user/EatLater.dart';
import 'package:food_delivery_app/user/EatNow.dart';
import 'package:food_delivery_app/user/MealDaily.dart';
import 'package:food_delivery_app/user/MealDaily2.dart';
import 'package:food_delivery_app/user/Menucard.dart';
import 'package:food_delivery_app/user/Utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CartData cartdata = new CartData();

  String flag = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Color.fromRGBO(185, 204, 252, 1)),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              title: Text(
                'Food App',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Helper().heading),
              ),
              backgroundColor: Helper().background,
              bottom: TabBar(
                labelColor: Helper().button,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: Helper().button,
                indicatorWeight: 5.0,
                tabs: [
                  Tab(text: "Eat Now"),
                  Tab(text: "Eat Later"),
                  Tab(text: "Eat Daily"),
                  Tab(text: "Meal Daily")
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              EatNow(cartData: cartdata),
              EatLater(),
              EatDaily(),
              flag == ""
                  ? MealDaily((value) => {
                        setState(() {
                          flag = value;
                        })
                      })
                  : MealDaily2(
                      (value) => {
                            setState(() {
                              flag = value;
                            })
                          },
                      flag)
            ],
          ),
        ),
      ),
    );
  }
}
