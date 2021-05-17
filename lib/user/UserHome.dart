import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/user/Utils.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Menucard.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
// import 'package:food_delivery_app/widgets/BestFoodWidget.dart';
// import 'package:food_delivery_app/widgets/PopularFoodsWidget.dart';
import 'package:food_delivery_app/widgets/SearchWidget.dart';
// import 'package:food_delivery_app/widgets/TopMenus.dart';

String _address = "Searching Location ...";
List<Marker> myMarker = [];
bool locationSet = false;
String dishType = "All";

class MapHomePage extends StatefulWidget {
  @override
  _MapHomePageState createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  LocationData _currentPosition;
  Marker marker;
  Location location = Location();
  LatLng tappedPoint = LatLng(19.0473, 73.0699);

  GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(19.0473, 73.0699);

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(19.0473, 73.0699), zoom: 14),
            onMapCreated: onMapCreated,
            onTap: _handleTap,
            markers: Set.from(myMarker),
            // mapType: MapType.hybrid,
            myLocationEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  getLoc();
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new MenuOptionSide(
                          automatic: false, address: _address),
                    ));
              },
              child: Text("DONE"),
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
    // location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
    //     ),
    //   );
    // });
  }

  _handleTap(LatLng abc) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true));
      tappedPoint = abc;
      print(tappedPoint);
      // _currentPosition = tappedPoint;
      // _currentPosition.latitude = tappedPoint.latitude;
    });
  }

  // void onMapCreated(controller) {
  //   setState(() {
  //     _controller = controller;
  //   });
  // }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(tappedPoint.latitude, tappedPoint.longitude);
    _getAddress(tappedPoint.latitude, tappedPoint.longitude).then(
      (value) {
        setState(
          () {
            _address = "${value.first.addressLine}";
            print("Address = " + _address);
          },
        );
      },
    );
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}

class HomePage extends StatefulWidget {
  bool automatic;
  HomePage({Key key, @required this.automatic}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEditingText = true;
  TextEditingController _editingController;
  bool _hasBeenPressed = false;

  LocationData _currentPosition;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(19.0473, 73.0699);

  @override
  void initState() {
    super.initState();
    if (widget.automatic && !(locationSet)) {
      getLoc();
    }
    _editingController = TextEditingController(text: _address);
    print(_address);
    // Navigator.pop(context);
    // Navigator.pushNamed(context, "home");
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField(context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    if (_isEditingText)
      return Container(
        width: totalWidth * 0.8,
        child: Center(
          child: TextField(
            onSubmitted: (newValue) {
              setState(() {
                _address = newValue;
                _isEditingText = false;
                locationSet = true;
              });
            },
            autofocus: true,
            controller: _editingController,
          ),
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        _address,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: TextStyle(
          color: Colors.black,
          fontSize: totalHeight * 15 / 700,
        ),
      ),
    );
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double totalWidth = MediaQuery.of(context).size.width;
        double totalHeight = MediaQuery.of(context).size.height;
        return Container(
          // color: Colors.grey,
          height: totalHeight / 3,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // color: Colors.grey,
                    height: totalHeight / 3,
                    // decoration: BoxDecoration(
                    //   color: Color(0xffdee8ff),
                    //   borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(20),
                    //     topRight: Radius.circular(20),
                    //   ),
                    // ),
                    decoration: BoxDecoration(
                        color: Color(0xffdee8ff),
                        border: Border.all(
                          color: Color(0xffaeb8ff),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: <Widget>[
                        Divider(
                          color: Colors.black12,
                        ),
                        Text(
                          "Select Delivery Address",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: totalHeight * 20 / 700,
                              fontFamily: "Robonto",
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.black12,
                        ),
                        SizedBox(
                          height: totalHeight * 15 / 700,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            SizedBox(width: totalWidth * 0.01),
                            Text("HOME",
                                style: TextStyle(
                                    fontSize: totalHeight * 18 / 700,
                                    fontFamily: "Robonto",
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                          height: totalHeight * 5 / 700,
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Icon(Icons.home),
                        //     SizedBox(width: totalWidth * 0.1),
                        Center(
                          child: _editTitleTextField(context),
                        ),
                        //   ],
                        // ),
                        SizedBox(
                          height: totalHeight * 15 / 700,
                        ),
                        Divider(
                          color: Colors.black12,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapHomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    totalHeight * 10 / 700)),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.add_location_sharp,
                                      color: Color(0xFF002140),
                                      size: totalHeight * 20 / 700),
                                ),
                                TextSpan(
                                  text: " Set Your Location Manually",
                                  style: TextStyle(
                                      color: Color(0xFF002140),
                                      fontSize: totalHeight * 20 / 700,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black12,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {});
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     primary: Colors.white,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.circular(totalHeight * 10 / 700)),
                        //   ),
                        //   child: Text(
                        //     "SELECT & PROCEED",
                        //     style: TextStyle(
                        //         color: Color(0xFF002140),
                        //         fontSize: totalHeight * 22 / 700,
                        //         fontWeight: FontWeight.normal),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    // double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    CartData cartdata = new CartData();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: Drawer(child: AppDrawer(automatic: widget.automatic)),
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        toolbarHeight: mediaQuery.size.height * 50 / 700,
        title: new RichText(
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Deliver to:\n',
                style: TextStyle(
                    fontSize: mediaQuery.size.height * 15 / 700,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: _address,
                style: TextStyle(
                  fontSize: mediaQuery.size.height * 13 / 700,
                  // maxLines: 3,
                  // overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showModalBottomSheet(context);
              setState(() {});
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MapHomePage(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: mediaQuery.size.height * 5 / 700,
            ),
            SearchWidget(),
            SizedBox(
              height: mediaQuery.size.height * 15 / 700,
            ),
            // Top Menu
            Container(
              height: totalHeight * 1.5 / 7,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  TopMenuTiles(context, "North Indian", "north_indian.jpg"),
                  TopMenuTiles(context, "West Indian", "west_indian.png"),
                  TopMenuTiles(context, "Maharashtrian", "maharashtrian.jpg"),
                  TopMenuTiles(context, "South Indian", "south_indian.jpeg"),
                  TopMenuTiles(
                      context, "North East Indian", "north_east_indian.jpg"),
                  TopMenuTiles(context, "Bengali", "bengali.jpg"),
                  TopMenuTiles(context, "All", "all.jpg"),
                  Divider(
                    height: totalHeight * 1 / 700,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            PopularFoodsWidget(cartData: cartdata),
            SizedBox(
              height: mediaQuery.size.height * 15 / 700,
            ),
            BestFoodWidget(cartData: cartdata),
          ],
        ),
      ),
    );
  }

  // class TopMenuTiles extends StatelessWidget {
  // String name;
  // String imageUrl;
  // String slug;

  // TopMenuTiles(
  //     {Key key,
  //     @required this.name,
  //     @required this.imageUrl,
  //     @required this.slug})
  //     : super(key: key);

  // @override
  Widget TopMenuTiles(context, String name, String imageUrl) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    // Color topMenuColor = Color(0xffdee8ff);
    // if (dishType == name) {}
    return InkWell(
      onTap: () {
        setState(() {
          dishType = name;
          print(dishType);
          // topMenuColor = Color(0xFFFF785B);
          // _hasBeenPressed = !_hasBeenPressed;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MenuOptionSide(automatic: false, address: _address),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: totalWidth * 15 / 420,
                right: totalWidth * 15 / 420,
                top: totalHeight * 5 / 700,
                bottom: totalHeight * 10 / 700),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: _hasBeenPressed ? Color(0xFFFF785B) : Color(0xffdee8ff),
                // color: topMenuColor,
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            // child: Card(
            //   color: Colors.orangeAccent[200],
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: const BorderRadius.all(
            //       Radius.circular(10.0),
            //     ),
            //   ),
            child: Container(
              decoration: BoxDecoration(
                color: Helper().button,
                border: new Border.all(
                  width: 1.5,
                  color: Helper().button,
                ),
                borderRadius: BorderRadius.circular(totalHeight * 0.1),
                // shape: BoxShape.circle
              ),
              width: totalWidth * 100 / 420,
              height: totalHeight * 1 / 9,
              child: CircleAvatar(
                backgroundColor: Helper().button,
                backgroundImage:
                    AssetImage('assets/images/topmenu/' + imageUrl),
                radius: totalHeight * 0.08,
              ),
            ),
            // ),
          ),
          Text(name,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: totalHeight * 16 / 700,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   print("${currentLocation.longitude} : ${currentLocation.longitude}");
    //   setState(() {
    //     _currentPosition = currentLocation;
    //     _initialcameraposition =
    //         LatLng(_currentPosition.latitude, _currentPosition.longitude);
    //     _getAddress(_currentPosition.latitude, _currentPosition.longitude)
    //         .then((value) {
    //       setState(() {
    //         _address = "${value.first.addressLine}";
    //       });
    //     });
    //   });
    // });
    _getAddress(_currentPosition.latitude, _currentPosition.longitude).then(
      (value) {
        setState(
          () {
            _address = "${value.first.addressLine}";
            print("Address = " + _address);
          },
        );
      },
    );
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}

class PopularFoodsWidget extends StatefulWidget {
  CartData cartData;
  PopularFoodsWidget({@required this.cartData});
  @override
  _PopularFoodsWidgetState createState() => _PopularFoodsWidgetState();
}

class _PopularFoodsWidgetState extends State<PopularFoodsWidget> {
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
          PopularFoodTitle(),
          Expanded(
            child: PopularFoodItems(),
          )
        ],
      ),
    );
  }
}

class PopularFoodTiles extends StatefulWidget {
  String name, dishName, image, time, chefId;
  dynamic rating;
  int quantity, count;
  dynamic price;
  CartData cartData;
  Function refresh;
  PopularFoodTiles(
      this.name,
      this.rating,
      this.price,
      this.dishName,
      this.image,
      this.time,
      this.quantity,
      this.cartData,
      this.chefId,
      this.refresh);
  @override
  _PopularFoodTilesState createState() => _PopularFoodTilesState();
}

class _PopularFoodTilesState extends State<PopularFoodTiles> {
  Helper help = new Helper();
  var canAdd = 1;

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
  void initState() {
    super.initState();
    // var total_remaining_time = int.parse(widget.time);
    checkCart_add();
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
                        Text('  Rating ' + widget.rating.toString() + ' ⭐',
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
                              Icons.remove_circle,
                              color: Helper().button,
                              size: totalHeight * 28 / 700,
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
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Helper().button,
                              size: totalHeight * 28 / 700,
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
                        // var cartDishName = CartData().getItem().where((element) => element.dish.getDishName()[0]=true);
                        // if (cartDishName.contains(widget.name)) {
                        if (canAdd == 1) {
                          CartData().addItem(
                              Dishes(
                                  widget.name,
                                  widget.rating,
                                  widget.dishName,
                                  widget.price,
                                  widget.image,
                                  widget.time,
                                  widget.dishName,
                                  widget.count,
                                  widget.chefId),
                              widget.quantity);
                          checkCart_add();
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuOptionSide(
                                    automatic: false, address: _address),
                              ),
                            );
                          });
                          Fluttertoast.showToast(
                              msg: "Showing " + widget.name + "'s food only",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Helper().button,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          widget.refresh();
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
            "Trending Chefs Nearby",
            style: TextStyle(
                fontSize: totalHeight * 20 / 700,
                color: Color(0xFF002140),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PopularFoodItems extends StatefulWidget {
  CartData cartData;
  Function refreshCartNumber;
  PopularFoodItems({this.cartData, this.refreshCartNumber});
  @override
  _PopularFoodItemsState createState() => _PopularFoodItemsState();
}

class _PopularFoodItemsState extends State<PopularFoodItems> {
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;
  int page_refresher = 1;
  Map chef = {};
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
                  chef = {};
                  for (int i = 0; i < snapshot2.data.docs.length; i++) {
                    // print(snapshot2.data.docs[i].data());
                    chef[snapshot2.data.docs[i].id] =
                        snapshot2.data.docs[i].data();
                  }
                  dishes = [];
                  if (dishType == "All") {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                      var dd = snapshot.data.docs[i];
                      if (chef_detail != null) {
                        Dishes dish = new Dishes(
                            chef_detail["fname"].toString(),
                            dd["rating"],
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
                  } else {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                      var dd = snapshot.data.docs[i];
                      if (chef_detail != null &&
                          dishType == dd["cuisineType"]) {
                        Dishes dish = new Dishes(
                            chef_detail["fname"].toString(),
                            dd["rating"],
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
                  dishes.sort((a, b) => b.getCount().compareTo(a.getCount()));
                  if (dishes.length > 10) dishes = dishes.take(10).toList();
                  // print(dishes);

                  return Row(
                      children: dishes.map((data) {
                    if (CartData.dishes.length == 0 ||
                        data.getChefId().toString() ==
                            CartData.dishes[0].dish.getChefId().toString()) {
                      // print(ll);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopularFoodTiles(
                            data.name,
                            data.getRating(),
                            data.getPrice(),
                            data.getDishName(),
                            data.getimage(),
                            data.gettime(),
                            1,
                            this.cartdata,
                            data.getChefId(),
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
    ]);
  }
}

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
            "Trending Foods Nearby",
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
  String name, dishName, image, time, chefId;
  dynamic rating;
  int quantity, count;
  dynamic price;
  CartData cartData;
  Function refresh;
  BestFoodTiles(this.name, this.rating, this.price, this.dishName, this.image,
      this.time, this.quantity, this.cartData, this.chefId, this.refresh);
  @override
  _BestFoodTilesState createState() => _BestFoodTilesState();
}

class _BestFoodTilesState extends State<BestFoodTiles> {
  Helper help = new Helper();
  var canAdd = 1;

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
  void initState() {
    super.initState();
    // var total_remaining_time = int.parse(widget.time);
    checkCart_add();
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
                              Icons.remove_circle,
                              color: Helper().button,
                              size: totalHeight * 28 / 700,
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
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Helper().button,
                              size: totalHeight * 28 / 700,
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
                          CartData().addItem(
                              Dishes(
                                  widget.name,
                                  widget.rating,
                                  widget.dishName,
                                  widget.price,
                                  widget.image,
                                  widget.time,
                                  widget.dishName,
                                  widget.count,
                                  widget.chefId),
                              widget.quantity);
                          checkCart_add();
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuOptionSide(
                                    automatic: false, address: _address),
                              ),
                            );
                          });
                          Fluttertoast.showToast(
                              msg: "Showing " + widget.name + "'s food only",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Helper().button,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          widget.refresh();
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

class BestFoodList extends StatefulWidget {
  CartData cartData;
  Function refreshCartNumber;
  BestFoodList({this.refreshCartNumber});
  @override
  _BestFoodListState createState() => _BestFoodListState();
}

class _BestFoodListState extends State<BestFoodList> {
  List<Dishes> l;
  CartData cartdata;
  Map ll;
  final db = FirebaseFirestore.instance;
  int page_refresher = 1;
  Map chef = {};
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
    this.cartdata = widget.cartData;
  }

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
                  chef = {};
                  for (int i = 0; i < snapshot2.data.docs.length; i++) {
                    // print(snapshot2.data.docs[i].data());
                    chef[snapshot2.data.docs[i].id] =
                        snapshot2.data.docs[i].data();
                  }
                  dishes = [];
                  if (dishType == "All") {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                      var dd = snapshot.data.docs[i];
                      if (chef_detail != null) {
                        Dishes dish = new Dishes(
                            chef_detail["fname"].toString(),
                            dd["rating"],
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
                  } else {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var chef_detail = chef[snapshot.data.docs[i]["chefId"]];
                      var dd = snapshot.data.docs[i];
                      if (chef_detail != null &&
                          dishType == dd["cuisineType"]) {
                        Dishes dish = new Dishes(
                            chef_detail["fname"].toString(),
                            dd["rating"],
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
                  dishes.sort((a, b) => b.getRating().compareTo(a.getRating()));
                  if (dishes.length > 10) dishes = dishes.take(10).toList();
                  // print(dishes);

                  return Row(
                      children: dishes.map((data) {
                    if (CartData.dishes.length == 0 ||
                        data.getChefId().toString() ==
                            CartData.dishes[0].dish.getChefId().toString()) {
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
                            this.cartdata,
                            data.getChefId(),
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
