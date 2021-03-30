// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Utils.dart';
import '../user/Chefdata.dart';

class EatNow extends StatefulWidget {
  CartData cartData;
  EatNow({@required this.cartData});
  @override
  _EatNowState createState() => _EatNowState();
}

class _EatNowState extends State<EatNow> {
  // Data2 f = new Data2();
  EatNowData items = new EatNowData();
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    this.l = items.getData();

    this.cartdata = widget.cartData;
    // this.data();
  }

// final db = FirebaseFirestore.instance;
//           CollectionReference collectionReference = db.collection('Chefs');
//           collectionReference.snapshots().listen((snapshot) {
//             for (int i = 0; i < snapshot.docs.length; i++) {
//               // chef[snapshot.docs[i].id] = snapshot.docs[i].data();
//               // print(snapshot.docs[i].id);
//               setState(() {
//                 ll = snapshot.docs[i].data();
//               });
//             }
//           });
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 248, 1),
      body: ListView(children: [
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
                          chef_detail["rating"]..toDouble(),
                          dd["dishName"].toString(),
                          dd["price"].toDouble(),
                          "panner_tikka.JPG",
                          "25 min");
                      dishes.add(dish);
                    }
                    print(dishes);

                    return Column(
                        children: dishes.map((data) {
                      print(ll);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleCard(
                            data.name,
                            data.rating,
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
      ]),
    );
  }
}

class SingleCard extends StatefulWidget {
  String name, dishName, image, time;
  double rating;
  int quantity;
  double price;
  CartData cartData;
  SingleCard(this.name, this.rating, this.price, this.dishName, this.image,
      this.time, this.quantity, this.cartData);
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
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
                                    fontSize: 16.0, color: help.heading)),
                            Text('Rating ' + widget.rating.toString() + ' ⭐',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w300)),
                          ])
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.dishName,
                      style: TextStyle(
                          color: help.heading, fontWeight: FontWeight.bold),
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
                                print(widget.quantity);
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
                                print(widget.quantity);
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
                  height: 100.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
                  ),
                  child: Image(
                    height: 100.0,
                    width: 150.0,
                    image: AssetImage("assets/images/${widget.image}"),
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
                        widget.cartData.addItem(
                            Dishes(widget.name, widget.rating, widget.dishName,
                                250, widget.image, widget.time),
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
      // child: Column(
      //   children: [
      //     ListTile(
      //       leading: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Icon(Icons.person),
      //       ),
      //       title: Text(name),
      //       subtitle: Text(
      //         'Rating ' + rating.toString() + ' ⭐',
      //         style: TextStyle(color: Colors.black.withOpacity(0.6)),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Text(
      //         dishName,
      //         style: TextStyle(color: Colors.black.withOpacity(1)),
      //       ),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.all(16.0),
      //       child: Image(
      //         image: AssetImage("assets/images/$image"),
      //       ),
      //     ),
      //     ButtonBar(
      //       alignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         ButtonBar(
      //           alignment: MainAxisAlignment.start,
      //           children: [
      //             Container(
      //               child: Text("5",
      //                   style: new TextStyle(
      //                       color: Colors.white, fontWeight: FontWeight.w900)),
      //               decoration: new BoxDecoration(
      //                   borderRadius:
      //                       new BorderRadius.all(new Radius.circular(10.0)),
      //                   color: Colors.grey),
      //               padding: new EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Perform some action
      //                 // f.getdata().map((e) => print(e.name));
      //               },
      //               style: ButtonStyle(
      //                   backgroundColor:
      //                       MaterialStateProperty.resolveWith<Color>(
      //                     (Set<MaterialState> states) {
      //                       if (states.contains(MaterialState.pressed))
      //                         return Colors.green;
      //                       return null; // Use the component's default.
      //                     },
      //                   ),
      //                   shape: MaterialStateProperty
      //                       .all<RoundedRectangleBorder>(RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(240.0),
      //                           side: BorderSide(color: Colors.transparent)))),
      //               child: Icon(Icons.add),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 // Perform some action
      //               },
      //               style: ButtonStyle(
      //                   shape: MaterialStateProperty
      //                       .all<RoundedRectangleBorder>(RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(140.0),
      //                           side: BorderSide(color: Colors.transparent)))),
      //               child: Icon(Icons.remove),
      //             ),
      //           ],
      //         ),
      //         ElevatedButton(
      //           onPressed: () {
      //             // Perform some action
      //           },
      //           style: ButtonStyle(
      //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //                   RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(140.0),
      //                       side: BorderSide(color: Colors.transparent)))),
      //           child: Icon(Icons.add_shopping_cart),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
