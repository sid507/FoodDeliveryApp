import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/ScaleRoute.dart';
import '../user/Chefdata.dart';
import '../user/FoodDetailsPage.dart';
import 'package:food_delivery_app/user/Utils.dart';

class BestFoodWidget extends StatefulWidget {
  CartData cartData;
  BestFoodWidget({@required this.cartData});
  @override
  _BestFoodWidgetState createState() => _BestFoodWidgetState();
}

class _BestFoodWidgetState extends State<BestFoodWidget> {
  EatNowData items = new EatNowData();
  List<Dishes> l;
  CartData cartdata;
  Map ll;

  @override
  void initState() {
    super.initState();
    this.l = items.getData();
    this.cartdata = widget.cartData;
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      height: totalHeight * 210 / 700,
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

class BestFoodTiles extends StatefulWidget {
  String name, dishName, image, time;
  dynamic rating;
  int quantity, count;
  dynamic price;
  CartData cartData;
  BestFoodTiles(this.name, this.rating, this.price, this.dishName, this.image,
      this.time, this.quantity, this.cartData);
  @override
  _BestFoodTilesState createState() => _BestFoodTilesState();
}

class _BestFoodTilesState extends State<BestFoodTiles> {
  Helper help = new Helper();
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Card(
      color: help.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(widget.name,
                                style: TextStyle(
                                    fontSize: totalHeight * 15 / 700,
                                    color: help.heading)),
                          ])
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.dishName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: help.heading, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: totalHeight * 5 / 700,
                        ),
                        Text('Rating ' + widget.rating.toString() + ' ⭐',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: totalHeight * 10 / 700,
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.price.toString() + "₹ (per serve)",
                      style: TextStyle(
                          color: help.normalText, fontWeight: FontWeight.w100),
                    ),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(widget.quantity.toString(),
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(10.0)),
                                color: help.button),
                            padding:
                                new EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Color.fromRGBO(232, 140, 48, 1),
                            ),
                            tooltip: 'Add',
                            onPressed: () => {
                              setState(() {
                                widget.quantity =
                                    help.addQuantity(widget.quantity);
                                // print(widget.quantity);
                              })
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color.fromRGBO(232, 140, 48, 1),
                            ),
                            tooltip: 'Delete',
                            onPressed: () => {
                              setState(() {
                                widget.quantity =
                                    help.delQuantity(widget.quantity);
                                // print(widget.quantity);
                              })
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Stack(children: [
                Container(
                  height: totalHeight * 1.5 / 7,
                  width: totalWidth * 3 / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.image,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                    right: 5,
                    bottom: -5,
                    left: 5,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (!states.contains(MaterialState.pressed))
                              return help.button.withOpacity(0.8);
                            return null; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        CartData().addItem(
                            Dishes(
                                widget.name,
                                widget.rating,
                                widget.dishName,
                                widget.price,
                                widget.image,
                                widget.time,
                                widget.dishName,
                                widget.count),
                            widget.quantity);
                      },
                      label: Text(
                        "ADD",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(
                        Icons.delivery_dining,
                        size: totalHeight * 30 / 700,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      widget.time,
                      style: TextStyle(
                          fontSize: totalHeight * 12 / 700,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.all(4.0),
                  ),
                )
              ])
            ]),
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
          // Text(
          //   "See all",
          //   style: TextStyle(
          //       fontSize: totalHeight * 16 / 700,
          //       color: Colors.blue,
          //       fontWeight: FontWeight.bold),
          // )
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
                  Map chef = {};
                  for (int i = 0; i < snapshot2.data.docs.length; i++) {
                    // print(snapshot2.data.docs[i].data());
                    chef[snapshot2.data.docs[i].id] =
                        snapshot2.data.docs[i].data();
                  }
                  List<Dishes> dishes = [];
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                    var dd = snapshot.data.docs[i];
                    if (chef_detail != null && dd["rating"] > 4) {
                      Dishes dish = new Dishes(
                          chef_detail["fname"].toString(),
                          dd["rating"],
                          dd["dishName"].toString(),
                          dd["price"].toDouble(),
                          dd["imageUrl"].toString(),
                          "25 min",
                          dd["mealType"],
                          dd["count"]);
                      dishes.add(dish);
                    }
                  }
                  dishes.sort((a, b) => b.getRating().compareTo(a.getRating()));
                  // print(dishes);

                  return Row(
                      children: dishes.map((data) {
                    // print(ll);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BestFoodTiles(
                          data.name,
                          data.getRating(),
                          data.getPrice(),
                          data.getDishName(),
                          data.getimage(),
                          data.gettime(),
                          1,
                          this.cartdata),
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
