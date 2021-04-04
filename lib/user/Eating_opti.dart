import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';

import 'package:food_delivery_app/user/Menucard.dart';
import 'package:food_delivery_app/widgets/drawer.dart';
import 'UserHome.dart';

class Eating extends StatefulWidget {
  @override
  _EatingState createState() => _EatingState();
}

class _EatingState extends State<Eating> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuOptionSide(automatic: false),
      drawer: AppDrawer(),
    );
  }
}

class EatingOption extends StatefulWidget {
  @override
  _EatingOptionState createState() => _EatingOptionState();
}

class _EatingOptionState extends State<EatingOption> {
  var textSize = 20.0;

  List<String> eating_time = [
    "Eat Now",
    "Eat Later",
    "Eat Tomorrow",
    "Eat Daily",
    "Meal Daily"
  ];

  FixedExtentScrollController fixedExtentScrollController =
      new FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
        // child: ListWheelScrollView(
        //   controller: fixedExtentScrollController,
        //   physics: FixedExtentScrollPhysics(),
        //   children: eating_time.map((month) {
        //     return Padding(
        //       padding: const EdgeInsets.all(20.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [createButton(month, Colors.white)],
        //       ),
        //     );
        //   }).toList(),
        //   itemExtent: 70.0,
        // ),
        child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: eating_time.map((data) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    createButton(data, Colors.white),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    ));
  }

  Widget createButton(String type, Color tc) {
    return Container(
      height: 90.0,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuOptionSide(automatic: false),
            ),
          );
        },

        // padding: EdgeInsets.all(0.0),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0))),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200.0, maxHeight: 90.0),
            alignment: Alignment.center,
            child: Text(
              type,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),

        onLongPress: () {
          print('Hey');
        },
      ),
    );
  }
}
