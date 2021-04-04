import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/ScaleRoute.dart';
import '../user/Chefdata.dart';
import '../user/FoodDetailsPage.dart';

class PopularFoodsWidget extends StatefulWidget {
  @override
  _PopularFoodsWidgetState createState() => _PopularFoodsWidgetState();
}

class _PopularFoodsWidgetState extends State<PopularFoodsWidget> {
  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      height: totalHeight * 315 / 700,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          PopularFoodTitle(),
          Expanded(
            child: PopularFoodItems(),
          )
        ],
      ),
    );
  }
}

class PopularFoodTiles extends StatelessWidget {
  String dishName;
  String imageUrl;
  double rating;
  String time;
  int numberOfRating;
  double price;
  String chefName;
  String mealType;
  CartData cartData;

  PopularFoodTiles({
    Key key,
    @required this.dishName,
    @required this.imageUrl,
    @required this.rating,
    @required this.numberOfRating,
    @required this.price,
    @required this.time,
    @required this.chefName,
    @required this.mealType,
    @required this.cartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          ScaleRoute(
            page: FoodDetailsPage(
              dishName: this.dishName,
              imageUrl: this.imageUrl,
              rating: this.rating,
              price: this.price,
              time: this.time,
              chefName: this.chefName,
              mealType: this.mealType,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
            width: totalWidth * 2 / 3,
            padding: EdgeInsets.only(
                left: totalWidth * 10 / 420,
                right: totalWidth * 5 / 420,
                top: totalHeight * 1 / 700,
                bottom: totalHeight * 1 / 700),
            child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: totalWidth * 190 / 420,
                  height: totalHeight * 200 / 700,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                width: totalWidth * 28 / 420,
                                height: totalHeight * 28 / 700,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFdee8ff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFdee8ff),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.favorite,
                                  color: Color(0xFFfb3132),
                                  size: totalHeight * 16 / 700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: totalWidth * 2 / 3,
                              height: totalHeight * 110 / 700)
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Center(
                          //       child: Image.network(
                          //     imageUrl,
                          //     width: totalWidth * 2 / 3,
                          //     height: totalHeight * 100 / 700,
                          //   )),
                          // )
                        ],
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  left: totalWidth * 5 / 420,
                                  top: totalHeight * 5 / 700),
                              child: Text(dishName,
                                  style: TextStyle(
                                      color: Color(0xFF6e6e71),
                                      fontSize: totalHeight * 15 / 700,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              padding:
                                  EdgeInsets.only(right: totalWidth * 5 / 420),
                              child: Container(
                                height: totalHeight * 28 / 420,
                                width: totalWidth * 28 / 420,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFdee8ff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFdee8ff),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.near_me,
                                  color: Color(0xFFfb3132),
                                  size: totalHeight * 16 / 700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      left: totalWidth * 5 / 420,
                                      top: totalHeight * 5 / 700),
                                  child: Text(rating.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF6e6e71),
                                          fontSize: totalHeight * 10 / 700,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: totalHeight * 3 / 700,
                                      left: totalWidth * 5 / 420),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        size: totalHeight * 10 / 700,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: totalHeight * 10 / 700,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: totalHeight * 10 / 700,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: totalHeight * 10 / 700,
                                        color: Color(0xFFfb3132),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: totalHeight * 10 / 700,
                                        color: Color(0xFF9b9b9c),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(
                                      left: totalWidth * 5 / 420,
                                      top: totalHeight * 5 / 700),
                                  child: Text("($numberOfRating)",
                                      style: TextStyle(
                                          color: Color(0xFF6e6e71),
                                          fontSize: totalHeight * 10 / 700,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  left: totalWidth * 5 / 420,
                                  top: totalHeight * 5 / 700,
                                  right: totalWidth * 5 / 420),
                              child: Text('\₹ ' + price.toString(),
                                  style: TextStyle(
                                      color: Color(0xFF6e6e71),
                                      fontSize: totalHeight * 12 / 700,
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class PopularFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(
          left: totalWidth * 10 / 420,
          right: totalWidth * 10 / 420,
          top: totalHeight * 5 / 700,
          bottom: totalHeight * 5 / 700),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Popular Foods",
            style: TextStyle(
                fontSize: totalHeight * 20 / 700,
                color: Color(0xFF002140),
                fontWeight: FontWeight.bold),
          ),
          Text(
            "See all",
            style: TextStyle(
                fontSize: totalHeight * 16 / 700,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class PopularFoodItems extends StatefulWidget {
  CartData cartData;
  @override
  _PopularFoodItemsState createState() => _PopularFoodItemsState();
}

class _PopularFoodItemsState extends State<PopularFoodItems> {
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.horizontal, children: [
      StreamBuilder<QuerySnapshot>(
        stream: db.collection('Food_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
              stream: db.collection('Chefs').snapshots(),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  Map chefs = {};
                  for (int i = 0; i < snapshot2.data.docs.length; i++) {
                    print(snapshot2.data.docs[i].data());
                    chefs[snapshot2.data.docs[i].id] =
                        snapshot2.data.docs[i].data();
                  }
                  List<Dishes> dishes = [];
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    var chef_detail = chefs[snapshot.data.docs[i]["chefId"]];
                    var dd = snapshot.data.docs[i];
                    Dishes dish = new Dishes(
                        chef_detail["chefName"].toString(),
                        dd["rating"],
                        dd["dishName"].toString(),
                        dd["price"].toDouble(),
                        dd["imageUrl"].toString(),
                        "25 min",
                        dd["mealType"]);
                    dishes.add(dish);
                  }
                  print(dishes);

                  return Row(
                      children: dishes.map((data) {
                    print(ll);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopularFoodTiles(
                        dishName: data.getDishName(),
                        price: data.getPrice(),
                        imageUrl: data.getimage(),
                        rating: data.getRating(),
                        time: data.gettime(),
                        numberOfRating: 200,
                        chefName: data.name,
                        mealType: data.getMealType(),
                        cartData: cartdata,
                      ),
                    );
                  }).toList());
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      )
    ]);
  }
}
