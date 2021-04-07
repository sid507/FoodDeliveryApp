import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/ScaleRoute.dart';
import '../user/Chefdata.dart';
import '../user/FoodDetailsPage.dart';

class BestFoodWidget extends StatefulWidget {
  @override
  _BestFoodWidgetState createState() => _BestFoodWidgetState();
}

class _BestFoodWidgetState extends State<BestFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BestFoodTitle(),
          Expanded(
            child: BestFoodList(),
          )
        ],
      ),
    );
  }
}

class BestFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(
          left: totalWidth * 10 / 420,
          right: totalWidth * 10 / 420,
          top: totalHeight * 1 / 700,
          bottom: totalHeight * 1 / 700),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Best Foods",
            style: TextStyle(
                fontSize: totalHeight * 2 / 70,
                color: Color(0xFF002140),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BestFoodTiles extends StatelessWidget {
  String dishName;
  String imageUrl;
  double rating;
  String time;
  int numberOfRating;
  double price;
  String chefName;
  String mealType;
  CartData cartData;

  BestFoodTiles({
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
                            ),
                          ),
                          SizedBox(
                              width: totalWidth * 2 / 3,
                              height: totalHeight * 110 / 700)
                        ],
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

class BestFoodList extends StatefulWidget {
  CartData cartData;
  @override
  _BestFoodListState createState() => _BestFoodListState();
}

class _BestFoodListState extends State<BestFoodList> {
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
              stream: db.collection('Chef').snapshots(),
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
                    if (chef_detail != null) {
                      Dishes dish = new Dishes(
                          chef_detail["fname"].toString(),
                          dd["rating"],
                          dd["dishName"].toString(),
                          dd["price"].toDouble(),
                          dd["imageUrl"].toString(),
                          "25 min",
                          dd["mealType"]);
                      dishes.add(dish);
                    }
                  }
                  print(dishes);

                  return Row(
                      children: dishes.map((data) {
                    print(ll);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BestFoodTiles(
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
            // for (int i = 0; i <elem; i++) {
            //   tp.add(snapshot.data.docs[i]);
            // }
            // print(tp);

          } else {
            return Container();
          }
        },
      )
    ]);
  }
}
