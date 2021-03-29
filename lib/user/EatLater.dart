import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Utils.dart';
import '../user/Chefdata.dart';

class EatLater extends StatefulWidget {
  @override
  _EatLaterState createState() => _EatLaterState();
}

class _EatLaterState extends State<EatLater> {
  EatNowData items = new EatNowData();
  List<Dishes> l;

  @override
  void initState() {
    super.initState();
    this.l = items.getData();
    l.map((e) => print(e.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: new Helper().background,
      body: ListView(
        children: l.map((data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleCard(data.name, data.rating, data.getDishName(),
                data.getimage(), '07:00', 1),
          );
        }).toList(),
      ),
    );
  }
}

class SingleCard extends StatefulWidget {
  String name, dishName, image, time;
  double rating;
  int quantity;
  SingleCard(this.name, this.rating, this.dishName, this.image, this.time,
      this.quantity);
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
                      "250₹ (per serve)",
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
                  height: totalHeight * 100 / 700,
                  width: totalWidth * 140 / 420,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
                  ),
                  child: Image(
                    height: totalHeight * 100 / 700,
                    width: totalWidth * 150 / 420,
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
                        // Respond to button press
                        CartData().addItem(
                            Dishes(widget.name, widget.rating, widget.dishName,
                                250, widget.image, widget.time),
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
