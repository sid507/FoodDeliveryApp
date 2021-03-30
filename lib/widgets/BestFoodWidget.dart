import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/Chefdata.dart';

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
  String name;
  String imageUrl;
  double rating;
  double price;

  BestFoodTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: totalWidth * 10 / 420,
                right: totalWidth * 5 / 420,
                top: totalHeight * 5 / 700,
                bottom: totalHeight * 5 / 700),
            decoration: BoxDecoration(boxShadow: [
              /* BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),*/
            ]),
            child: Card(
              // semanticContainer: true,
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(imageUrl, width: totalWidth * 0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(5),
            ),
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
    return ListView(children: [
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
                        "25 min");
                    dishes.add(dish);
                  }
                  print(dishes);

                  return Column(
                      children: dishes.map((data) {
                    print(ll);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BestFoodTiles(
                        name: data.getDishName(),
                        price: data.getPrice(),
                        imageUrl: data.getimage(),
                        rating: data.getRating(),
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
