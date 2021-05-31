import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/EatDaily.dart';
import 'package:food_delivery_app/user/Utils.dart';
import 'package:food_delivery_app/user/ScaleRoute.dart';
import 'package:food_delivery_app/user/Menucard.dart';
import '../user/Chefdata.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

final now = new DateTime.now();

class SearchPage extends StatefulWidget {
  CartData cartData;
  String address;
  String searchText;
  Function refreshCartNumber;
  SearchPage(
      {this.cartData,
      @required this.searchText,
      @required this.address,
      @required this.refreshCartNumber});
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
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    int flag = 1;
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
              if (!snapshot.data.docs[i]['dishName']
                  .toLowerCase()
                  .contains(widget.searchText.toLowerCase())) {
                flag = 0;
                break;
              }
            }
          }
          // if (flag == 1)
          //   return NoItemsFound();
          // else
          return ItemsFound(
            address: widget.address,
            refreshCartNumber: widget.refreshCartNumber,
            searchText: widget.searchText,
            cartData: cartdata,
          );
        },
      ),
    );
  }
}

class ItemsFound extends StatefulWidget {
  final CartData cartData;
  final String address;
  final String searchText;
  final Function refreshCartNumber;
  ItemsFound(
      {this.cartData,
      @required this.searchText,
      @required this.address,
      @required this.refreshCartNumber});
  @override
  _ItemsFoundState createState() => _ItemsFoundState();
}

class _ItemsFoundState extends State<ItemsFound> {
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;
  int page_refresher = 1;
  Map chefs = {};
  List<Dishes> dishes = [];

  @override
  void initState() {
    super.initState();
    this.cartdata = widget.cartData;
    refresher_funct();
  }

  void refresher_funct() {
    // (context as Element).reassemble();
    print("ssssssssssssssssssssssssssssssssssssssssss");
    // print()
    // if (CartData.dishes.isNotEmpty)
    //   Fluttertoast.showToast(
    //       msg: "Showing " + CartData.dishes[0].dish.name + "'s food only",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Helper().button,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    setState(() {
      dishes = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 248, 1),
      body: Container(
        width: totalWidth,
        height: totalHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/not_f.png"),
              fit: BoxFit.fitWidth),
        ),
        child: ListView(
          children: [
            Center(
              child: OutlinedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!states.contains(MaterialState.pressed))
                        return Helper().button.withOpacity(0.8);
                      return null; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new MenuOptionSide(
                            automatic: false, address: widget.address),
                      ));
                },
                label: Text(
                  "BACK",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                icon: Icon(
                  Icons.arrow_left,
                  size: totalHeight * 30 / 700,
                  color: Colors.white,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('Food_items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: db.collection('Chef').snapshots(),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        DateTime tomorrow;
                        chefs = {};
                        for (int i = 0; i < snapshot2.data.docs.length; i++) {
                          // print(snapshot2.data.docs[i].data());
                          chefs[snapshot2.data.docs[i].id] =
                              snapshot2.data.docs[i].data();
                        }
                        print(chefs);
                        dishes = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          if (snapshot.data.docs[i]['dishName']
                              .toLowerCase()
                              .contains(widget.searchText.toLowerCase())) {
                            var chef_detail =
                                chefs[snapshot.data.docs[i]["chefId"]];
                            // print(chef_detail);
                            var dd = snapshot.data.docs[i];
                            TimeOfDay nowTime = TimeOfDay.now();
                            double currentTime = toDouble(nowTime);

                            double itemToTime1 =
                                double.parse(dd["toTime"].split(':')[0]);
                            double itemToTime2 =
                                double.parse(dd["toTime"].split(':')[1]);
                            double itemToTime =
                                itemToTime1 + itemToTime2 / 60.0;

                            if (currentTime <= itemToTime) {
                              tomorrow = DateTime(now.year, now.month, now.day);
                            } else {
                              tomorrow =
                                  DateTime(now.year, now.month, now.day + 1);
                            }
                            Dishes dish = new Dishes(
                                chef_detail["fname"].toString(),
                                chef_detail["chefAddress"].toString(),
                                chef_detail["rating"].toDouble(),
                                dd["dishName"].toString(),
                                dd["self_delivery"],
                                dd["price"].toDouble(),
                                dd["imageUrl"].toString(),
                                '25 mins',
                                dd["mealType"],
                                dd["count"],
                                dd["chefId"],
                                dd["toTime"],
                                dd["fromTime"],
                                DateFormat('dd MMM y')
                                    .format(tomorrow)
                                    .toString());
                            dishes.add(dish);
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
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: SingleCard(
                                  data.name,
                                  data.chefAddress,
                                  data.rating,
                                  data.getPrice(),
                                  data.getDishName(),
                                  data.getSelfDelivery(),
                                  data.getimage(),
                                  data.gettime(),
                                  data.getCount(),
                                  this.cartdata,
                                  data.getChefId().toString(),
                                  data.getToTime(),
                                  data.getFromTime(),
                                  () => {
                                        widget.refreshCartNumber(),
                                        refresher_funct()
                                      },
                                  widget.searchText,
                                  widget.address,
                                  widget.refreshCartNumber),
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
            ),
            // Center(
            //   child: OutlinedButton.icon(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.resolveWith<Color>(
            //         (Set<MaterialState> states) {
            //           if (!states.contains(MaterialState.pressed))
            //             return Helper().button.withOpacity(0.8);
            //           return null; // Use the component's default.
            //         },
            //       ),
            //     ),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => new MenuOptionSide(),
            //           ));
            //     },
            //     label: Text(
            //       "BACK",
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.bold),
            //     ),
            //     icon: Icon(
            //       Icons.arrow_left,
            //       size: totalHeight * 30 / 700,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
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
  String name, chefAddress, dishName, image, time, chefId, toTime, fromTime;
  bool self_delivery;
  dynamic rating;
  int quantity, count;
  dynamic price;
  CartData cartData;
  Function refresh;
  String searchText;
  String address;
  Function refreshCartNumber;
  SingleCard(
      this.name,
      this.chefAddress,
      this.rating,
      this.price,
      this.dishName,
      this.self_delivery,
      this.image,
      this.time,
      this.quantity,
      this.cartData,
      this.chefId,
      this.toTime,
      this.fromTime,
      this.refresh,
      this.searchText,
      this.address,
      this.refreshCartNumber);
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  Helper help = new Helper();
  var canAdd = 1;
  int canIncrease = 1;
  int itemCount = 1;
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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  void dispose() {
    super.dispose();
    // canAdd=0;
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;

    return Container(
      // width: totalWidth * 4 / 6,
      // height: totalHeight * 1 / 3,
      color: Colors.white,
      child: Card(
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
                            color: help.normalText,
                            fontWeight: FontWeight.w100),
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
                              child: Text(itemCount.toString(),
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900)),
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0)),
                                  color: help.button),
                              padding: new EdgeInsets.fromLTRB(
                                  16.0, 10.0, 16.0, 10.0),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle,
                                color: Helper().button,
                                size: totalHeight * 28 / 700,
                              ),
                              tooltip: 'Delete',
                              onPressed: () => {
                                setState(() {
                                  itemCount = help.delQuantity(itemCount);
                                  print(itemCount);
                                }),
                                if (itemCount < widget.quantity)
                                  {
                                    setState(() {
                                      canIncrease = 1;
                                    })
                                  },
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: canIncrease == 1
                                    ? Helper().button
                                    : Colors.grey,
                                size: totalHeight * 28 / 700,
                              ),
                              tooltip: 'Add',
                              onPressed: () => {
                                if (widget.quantity > itemCount)
                                  {
                                    setState(() {
                                      itemCount = help.addQuantity(itemCount);
                                      print(itemCount);
                                    }),
                                    if (widget.quantity == itemCount)
                                      {
                                        setState(() {
                                          canIncrease = 0;
                                        })
                                      }
                                  }
                                else
                                  {
                                    setState(() {
                                      canIncrease = 0;
                                    }),
                                    Fluttertoast.showToast(
                                        msg: "Order Limit Exceeded",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Helper().button,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                  }
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
                    right: 4,
                    top: 3,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.red.withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '${widget.fromTime}-${widget.toTime}',
                        style: TextStyle(
                            fontSize: totalHeight * 12 / 700,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.all(4.0),
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
                            DateTime tomorrow;
                            TimeOfDay nowTime = TimeOfDay.now();
                            double currentTime = toDouble(nowTime);

                            double itemToTime1 =
                                double.parse(widget.toTime.split(':')[0]);
                            double itemToTime2 =
                                double.parse(widget.toTime.split(':')[1]);
                            double itemToTime =
                                itemToTime1 + itemToTime2 / 60.0;

                            if (currentTime <= itemToTime) {
                              tomorrow = DateTime(now.year, now.month, now.day);
                            } else {
                              tomorrow =
                                  DateTime(now.year, now.month, now.day + 1);
                            }
                            CartData().addItem(
                                Dishes(
                                    widget.name,
                                    widget.chefAddress,
                                    widget.rating,
                                    widget.dishName,
                                    widget.self_delivery,
                                    widget.price,
                                    widget.image,
                                    widget.time,
                                    widget.dishName,
                                    widget.count,
                                    widget.chefId.toString(),
                                    widget.toTime,
                                    widget.fromTime,
                                    DateFormat('dd MMM y')
                                        .format(tomorrow)
                                        .toString()),
                                itemCount);
                            String msg;
                            if (CartData.dishes.length < 2) {
                              msg = "Showing " + widget.name + "'s food only";
                            } else {
                              msg = "Successfully Added";
                            }
                            Fluttertoast.showToast(
                                msg: msg,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Helper().button,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            // widget.refresh();
                            // checkCart_add();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new SearchPage(
                                        address: widget.address,
                                        refreshCartNumber:
                                            widget.refreshCartNumber,
                                        searchText: widget.searchText)));
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
                  // Positioned(
                  //   right: 3,
                  //   top: 3,
                  //   child: Container(
                  //     decoration: new BoxDecoration(
                  //       color: Colors.red.withOpacity(0.6),
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     ),
                  //     child: Text("25 mins"),
                  //     padding: EdgeInsets.all(4.0),
                  //   ),
                  // )
                ])
              ]),
        ),
      ),
    );
  }
}
