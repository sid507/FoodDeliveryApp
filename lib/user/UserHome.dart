import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:food_delivery_app/widgets/drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ScaleRoute.dart';
import 'Cart.dart';
import 'Menucard.dart';
import 'package:food_delivery_app/widgets/BestFoodWidget.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';
import 'package:food_delivery_app/widgets/PopularFoodsWidget.dart';
import 'package:food_delivery_app/widgets/SearchWidget.dart';
import 'package:food_delivery_app/widgets/TopMenus.dart';
import 'package:food_delivery_app/widgets/AppBarWidget.dart';

String _address = "Searching Location ...";
List<Marker> myMarker = [];

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
            mapType: MapType.hybrid,
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
                      builder: (context) => MenuOptionSide(automatic: false),
                    ),
                  );
                },
                child: Text("DONE"),
              )),
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
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = _address;

  LocationData _currentPosition;
  GoogleMapController mapController;
  Marker marker;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(19.0473, 73.0699);

  @override
  void initState() {
    super.initState();
    if (widget.automatic) {
      getLoc();
    }
  }

  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(child: AppDrawer(automatic: widget.automatic)),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapHomePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchWidget(),
            TopMenus(),
            PopularFoodsWidget(),
            BestFoodWidget(),
            SizedBox(
              height: mediaQuery.size.height * 15 / 700,
            )
          ],
        ),
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
