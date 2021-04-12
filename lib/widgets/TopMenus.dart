import 'package:flutter/material.dart';

import '../user/MenuCard.dart';
import 'package:food_delivery_app/user/Utils.dart';

class TopMenus extends StatefulWidget {
  @override
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      height: totalHeight * 1.5 / 7,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          TopMenuTiles(
              name: "North Indian", imageUrl: "north_indian.jpg", slug: ""),
          TopMenuTiles(
              name: "West Indian", imageUrl: "west_indian.png", slug: ""),
          TopMenuTiles(
              name: "Maharashtrian", imageUrl: "maharashtrian.jpg", slug: ""),
          TopMenuTiles(
              name: "South Indian", imageUrl: "south_indian.jpeg", slug: ""),
          TopMenuTiles(
              name: "North East Indian",
              imageUrl: "north_east_indian.jpg",
              slug: ""),
          TopMenuTiles(name: "Bengali", imageUrl: "bengali.jpg", slug: ""),
          TopMenuTiles(name: "Ice Cream", imageUrl: "ice_cream.jpg", slug: ""),
          TopMenuTiles(
              name: "Soft Drink", imageUrl: "soft_drink.jpeg", slug: ""),
          Divider(
            height: totalHeight * 1 / 700,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class TopMenuTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MenuOptionSide(automatic: false),
        //   ),
        // );
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: totalWidth * 15 / 420,
                right: totalWidth * 15 / 420,
                top: totalHeight * 5 / 700,
                bottom: totalHeight * 10 / 700),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xffdee8ff),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            // child: Card(
            //   color: Colors.orangeAccent[200],
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: const BorderRadius.all(
            //       Radius.circular(10.0),
            //     ),
            //   ),
            child: Container(
              decoration: BoxDecoration(
                color: Helper().button,
                border: new Border.all(
                  width: 1.5,
                  color: Helper().button,
                ),
                borderRadius: BorderRadius.circular(totalHeight * 0.1),
                // shape: BoxShape.circle
              ),
              width: totalWidth * 100 / 420,
              height: totalHeight * 1 / 9,
              child: CircleAvatar(
                backgroundColor: Helper().button,
                backgroundImage:
                    AssetImage('assets/images/topmenu/' + imageUrl),
                radius: totalHeight * 0.08,
              ),
            ),
            // ),
          ),
          Text(name,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: totalHeight * 16 / 700,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
