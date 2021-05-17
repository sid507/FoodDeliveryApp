import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';

import 'package:food_delivery_app/user/Utils.dart';
import '../user/Chefdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool found = true;

class SearchPage extends StatefulWidget {
  final String searchText;
  Function refreshCartNumber;
  SearchPage({Key key, @required this.searchText, this.refreshCartNumber})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  EatNowData items = new EatNowData();
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    this.l = items.getData();
    // StreamBuilder<QuerySnapshot>(
    //   stream: db.collection('Food_items').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       for (int i = 0; i < snapshot.data.docs.length; i++) {
    //         if (snapshot.data.docs[i]['dishName']
    //             .toLowerCase()
    //             .contains(widget.searchText.toLowerCase())) {
    //           found = true;
    //           print("found = $found");
    //           break;
    //         }
    //       }
    //       return ColoredCircularProgressIndicator();
    //     } else {
    //       return ColoredCircularProgressIndicator();
    //     }
    //   },
    // );
    // print("found = $found");
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Helper().background,
          automaticallyImplyLeading: false,
          title: Text(
            "Search",
            style:
                TextStyle(color: Helper().heading, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromRGBO(247, 247, 248, 1),
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Food_items').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (int i = 0; i < snapshot.data.docs.length; i++) {
                  if (snapshot.data.docs[i]['dishName']
                      .toLowerCase()
                      .contains(widget.searchText.toLowerCase())) {
                    return ItemsFound(
                      searchText: widget.searchText,
                      cartData: cartdata,
                    );
                  }
                }
              }
              return NoItemsFound();
            })
        // for (int i = 0; i <elem; i++) {
        //   tp.add(snapshot.data.docs[i]);
        // }
        // print(tp);

        // } else {
        //   return NoItemsFound();
        // }
        // : Container(
        //     width: totalWidth,
        //     height: totalHeight,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage("assets/images/search_not_found.PNG"),
        //           fit: BoxFit.fitWidth),
        //     ),
        //   ),
        );
  }
}

class ItemsFound extends StatefulWidget {
  final String searchText;
  CartData cartData;
  Function refreshCartNumber;
  ItemsFound(
      {@required this.cartData,
      @required this.searchText,
      this.refreshCartNumber});
  @override
  _ItemsFoundState createState() => _ItemsFoundState();
}

class _ItemsFoundState extends State<ItemsFound> {
  EatNowData items = new EatNowData();
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;
  int page_refresher = 1;
  Map chefs = {};
  List<Dishes> dishes = [];

  void refresher_funct() {
    // (context as Element).reassemble();
    print("ssssssssssssssssssssssssssssssssssssssssss");
    // print()
    if (CartData.dishes.isNotEmpty)
      Fluttertoast.showToast(
          msg: "Showing " + CartData.dishes[0].dish.name + "'s food only",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Helper().button,
          textColor: Colors.white,
          fontSize: 16.0);
    setState(() {
      dishes = [];
    });
    // rebuildAllChildren(context);
    // EatNow(cartData: new CartData());

    // Navigator.push(context,
    //     new MaterialPageRoute(builder: (context) => this.build(context)));
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  @override
  void initState() {
    super.initState();
    this.l = items.getData();
    this.cartdata = widget.cartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 248, 1),
        body: ListView(children: [
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('Food_items').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print("found = $found");
                return StreamBuilder<QuerySnapshot>(
                  stream: db.collection('Chef').snapshots(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      Map chefs = {};
                      for (int i = 0; i < snapshot2.data.docs.length; i++) {
                        // print(snapshot2.data.docs[i].data());
                        chefs[snapshot2.data.docs[i].id] =
                            snapshot2.data.docs[i].data();
                      }
                      print(chefs);
                      List<Dishes> dishes = [];
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        print(chefs);
                        if (snapshot.data.docs[i]['dishName']
                            .toLowerCase()
                            .contains(widget.searchText.toLowerCase())) {
                          var chef_detail =
                              chefs[snapshot.data.docs[i]["chefId"]];
                          // print(chef_detail);
                          var dd = snapshot.data.docs[i];
                          print(chef_detail);
                          if (chef_detail != null) {
                            Dishes dish = new Dishes(
                                chef_detail["fname"].toString(),
                                chef_detail["rating"].toDouble(),
                                dd["dishName"].toString(),
                                dd["price"].toDouble(),
                                dd["imageUrl"].toString(),
                                "25 min",
                                dd["mealType"],
                                dd["count"],
                                dd["chefId"]);
                            dishes.add(dish);
                          }
                        }
                      }
                      print(dishes);

                      return Column(
                          children: dishes.map((data) {
                        if (CartData.dishes.length == 0 ||
                            data.getChefId().toString() ==
                                CartData.dishes[0].dish
                                    .getChefId()
                                    .toString()) {
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
                                this.cartdata,
                                data.getChefId().toString(),
                                () => {
                                      widget.refreshCartNumber(),
                                      refresher_funct()
                                    }),
                          );
                        } else {
                          return Container();
                        }
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
        ]));
  }
}

class NoItemsFound extends StatefulWidget {
  @override
  _NoItemsFoundState createState() => _NoItemsFoundState();
}

class _NoItemsFoundState extends State<NoItemsFound> {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      width: totalWidth,
      height: totalHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/search_not_found.PNG"),
            fit: BoxFit.fitWidth),
      ),
    );
  }
}

class SingleCard extends StatefulWidget {
  String name, dishName, image, time, chefId;
  dynamic rating;
  int quantity, count;
  dynamic price;
  CartData cartData;
  Function refresh;
  SingleCard(this.name, this.rating, this.price, this.dishName, this.image,
      this.time, this.quantity, this.cartData, this.chefId, this.refresh);
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  Helper help = new Helper();
  var canAdd = 1;

  @override
  void initState() {
    super.initState();
    // var total_remaining_time = int.parse(widget.time);
    checkCart_add();
  }

  void checkCart_add() {
    for (int i = 0; i < CartData.dishes.length; i++) {
      if (CartData.dishes[i].dish.getDishName() == widget.dishName &&
          CartData.dishes[i].dish.name == widget.name) {
        setState(() {
          canAdd = 0;
        });
      }
    }
  }

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
                              Icons.remove_circle,
                              color: Helper().button,
                              size: 30,
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
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Helper().button,
                              size: 30,
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
                            if (canAdd != 1) {
                              return Colors.grey.withOpacity(0.8);
                            }
                            if (!states.contains(MaterialState.pressed))
                              return help.button.withOpacity(0.8);
                            return null; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        if (canAdd == 1) {
                          widget.cartData.addItem(
                              Dishes(
                                  widget.name,
                                  widget.rating,
                                  widget.dishName,
                                  widget.price,
                                  widget.image,
                                  widget.time,
                                  widget.dishName,
                                  widget.count,
                                  widget.chefId.toString()),
                              widget.quantity);
                          Fluttertoast.showToast(
                              msg: "Showing " + widget.name + "'s food only",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Helper().button,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          widget.refresh();
                          checkCart_add();
                        }
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
