import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Utils.dart';
import '../user/Chefdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EatLater extends StatefulWidget {
  @override
  _EatLaterState createState() => _EatLaterState();
}

class _EatLaterState extends State<EatLater> {
  EatNowData items = new EatNowData();
  List<Dishes> l;
  Map ll;
  final db = FirebaseFirestore.instance;

  Map timetable = {7: "Breakfast", 12: "Lunch", 17: "Dinner"};

  @override
  void initState() {
    super.initState();
    this.l = items.getData();
    l.map((e) => print(e.name));
  }

  String tellMeType(int p) {
    if (p >= 7 && p <= 12) {
      return "Lunch";
    } else if (p > 12 && p <= 17) {
      return "Dinner";
    } else {
      return "BreakFast";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Helper().background,
      body: ListView(children: [
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
                      print(snapshot2.data.docs[i].data());
                      chef[snapshot2.data.docs[i].id] =
                          snapshot2.data.docs[i].data();
                    }
                    List<Dishes> dishes = [];
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      final now = new DateTime.now();

                      // var fmt = DateFormat("HH:mm");
                      // print(fmt.format(now));

                      // DateTime tempDate = new DateFormat("hh:mm")
                      //     .parse(snapshot.data.docs[i]['fromTime']);

                      // DateTime tempDate2 = new DateFormat("hh:mm")
                      //     .parse(snapshot.data.docs[i]['toTime']);

                      // String sort_key = "";

                      // int flag = 0;
                      // timetable.forEach((key, value) {
                      //   if (now.hour >= key && flag == 0) {
                      //     print(key);
                      //     sort_key = timetable[(key + 5) > 17 ? 17 : key + 5];
                      //     flag = 1;
                      //   }
                      // });
                      // print(sort_key);

                      // now.hour >= tempDate.hour &&
                      // now.hour <= tempDate2.hour &&

                      if (snapshot.data.docs[i]['mealType'].toLowerCase() ==
                          this.tellMeType(now.hour).toLowerCase()) {
                        var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                        // print(chef_detail);
                        var dd = snapshot.data.docs[i];
                        if (chef_detail != null) {
                          Dishes dish = new Dishes(
                              chef_detail["fname"].toString(),
                              chef_detail["rating"].toDouble(),
                              dd["dishName"].toString(),
                              dd["price"].toDouble(),
                              dd["imageUrl"].toString(),
                              "25 min",
                              dd["mealType"]);
                          dishes.add(dish);
                        }
                      }
                    }
                    print(dishes);

                    return Column(
                        children: dishes.map((data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleCard(
                            data.name,
                            data.rating,
                            data.getPrice(),
                            data.getDishName(),
                            data.getimage(),
                            "07:00",
                            1),
                      );
                    }).toList());
                  } else {
                    return Container(
                      child: Center(
                        child: Text('Sorry....No Items are availble'),
                      ),
                    );
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

      // ListView(
      //   children: l.map((data) {
      //     return Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: SingleCard(data.name, data.rating, data.getDishName(),
      //           data.getimage(), '07:00', 1),
      //     );
      //   }).toList(),
      // ),
    );
  }
}

class SingleCard extends StatefulWidget {
  String name, dishName, image, time;
  dynamic rating;
  int quantity;
  dynamic price;
  SingleCard(this.name, this.rating, this.price, this.dishName, this.image,
      this.time, this.quantity);
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  Helper help = new Helper();
  TimeOfDay _ttime = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _ttime,
    );
    if (newTime != null) {
      setState(() {
        _ttime = newTime;
        widget.time = (_ttime.hour.toString() + ':' + _ttime.minute.toString())
            .toString();
      });
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
                mainAxisAlignment: MainAxisAlignment.end,
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
                            Text(widget.name, style: TextStyle(fontSize: 16.0)),
                            Text('Rating ' + widget.rating.toString() + ' ⭐',
                                style: TextStyle(
                                    fontSize: totalHeight * 10 / 700,
                                    fontWeight: FontWeight.w300)),
                          ])
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      widget.dishName,
                      style: TextStyle(
                          color: help.heading, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      widget.price.toString() + "₹ (per serve)",
                      style: TextStyle(
                          color: help.normalText, fontWeight: FontWeight.w100),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: OutlinedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (!states.contains(MaterialState.pressed))
                                return help.button;
                              return null; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: _selectTime,
                        label: Text(
                          widget.time,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.timer_rounded,
                          size: totalHeight * 20 / 700,
                          color: Colors.white,
                        ),
                      )),
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
                              color: help.button,
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
                            icon: Icon(
                              Icons.remove,
                              color: help.button,
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
                        // Respond to button press
                        CartData().addItem(
                            Dishes(
                                widget.name,
                                widget.rating,
                                widget.dishName,
                                widget.price,
                                widget.image,
                                widget.time,
                                widget.dishName),
                            widget.quantity);
                      },
                      label: Text(
                        "ADD +",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(
                        Icons.delivery_dining,
                        size: totalHeight * 30 / 700,
                        color: Colors.white,
                      ),
                    ))
              ])
            ]),
      ),
    );
  }
}

// Column(
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
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             dishName,
//             style: TextStyle(color: Colors.black.withOpacity(1)),
//           ),
//           Text('Price: 250₹')
//         ],
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Image(
//         image: AssetImage("assets/images/$image"),
//       ),
//     ),
//     Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
//       child: Row(
//         children: [
//           Text(
//             'Delivery At: ',
//             style: TextStyle(fontSize: 15.0),
//           ),
//           ElevatedButton(
//             onPressed: _selectTime,
//             child: Text(
//                 _time.hour.toString() + ':' + _time.minute.toString()),
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                   (Set<MaterialState> states) {
//                     if (states.contains(MaterialState.pressed))
//                       return Colors.green;
//                     return null; // Use the component's default.
//                   },
//                 ),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(240.0),
//                         side: BorderSide(color: Colors.transparent)))),
//           ),
//         ],
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
