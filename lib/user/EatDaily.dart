import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/user/Utils.dart';

class EatDaily extends StatefulWidget {
  @override
  _EatDailyState createState() => _EatDailyState();
}

class _EatDailyState extends State<EatDaily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleCard(
                "Siddharth Mishra", 4.5, "Maharashtrian", "north_indian.JPG"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleCard("Nishant Pal", 4.7, "South Indian", "dosa.jpg"),
          ),
        ],
      ),
    );
  }

  Widget SingleCard(String name, double rating, String dishtype, String image) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Helper().card,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Stack(children: [
              Image(
                // height: 100.0,
                width: double.infinity,
                image: AssetImage("assets/images/$image"),
              ),
              Positioned(
                  right: 0,
                  top: 5,
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (!states.contains(MaterialState.pressed))
                            return Helper().button;
                          return null; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      // Respond to button press
                    },
                    label: Text(
                      dishtype,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(
                      Icons.dinner_dining,
                      size: 30,
                      color: Colors.white,
                    ),
                  ))
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.person),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 16.0)),
                        Text('Rating ' + rating.toString() + ' ⭐',
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.w300)),
                      ]),
                ],
              ),
              OutlinedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!states.contains(MaterialState.pressed))
                        return Helper().button.withOpacity(1);
                      return null; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  // Respond to button press

                  CartData().addItem(
                      Dishes(name, rating, dishtype, 0, image, "0", "Lunch", 5),
                      0);
                },
                label: Text(
                  "Subscribe",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                icon: Icon(Icons.favorite, size: 18, color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }
}
