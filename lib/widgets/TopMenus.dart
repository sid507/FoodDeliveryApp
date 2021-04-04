import 'package:flutter/material.dart';

import '../user/MenuCard.dart';

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
      height: totalHeight * 2 / 7,
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
                left: totalWidth * 1 / 420,
                right: totalWidth * 1 / 420,
                top: totalHeight * 1 / 700,
                bottom: totalHeight * 1 / 700),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFdee8ff),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/topmenu/' + imageUrl),
                        fit: BoxFit.cover),
                  ),
                  width: totalWidth * 120 / 420,
                  height: totalHeight * 1 / 7,
                  // child: Center(
                  //     child: Image.asset(
                  //   'assets/images/topmenu/' + imageUrl,
                  //   width: totalWidth * 80 / 420,
                  //   height: totalHeight * 80 / 700,
                  // )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF002140),
                  fontSize: totalHeight * 16 / 700,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
