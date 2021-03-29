// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart' as geoCo;
// import 'package:geolocator/geolocator.dart';

// String finalAddress = "Searching Address...";

// class GoogleMapPage extends ChangeNotifier {
//   Position position;

//   Future getCurrentLocation() async {
//     var positionData = await GeolocatorPlatform.instance.getCurrentPosition();
//     final cords =
//         geoCo.Coordinates(positionData.latitude, positionData.latitude);
//     var address =
//         await geoCo.Geocoder.local.findAddressesFromCoordinates(cords);
//     String mainAddress = address.first.addressLine;
//     print(mainAddress);
//     finalAddress = mainAddress;
//     notifyListeners();
//   }
// }

// class GoogleMapPage extends StatefulWidget {
//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(19.0473, 73.0699),
//               zoom: 18,
//             ),
//             onMapCreated: (GoogleMapController controller) {},
//             MapPageEnabled: true,
//           ))
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   LocationData _currentPosition;
//   GoogleMapController mapController;
//   String _address;
//   Marker marker;
//   Location location = Location();

//   GoogleMapController _controller;
//   LatLng _initialcameraposition = LatLng(19.0473, 73.0699);

//   @override
//   void initState() {
//     super.initState();
//     getLoc();
//   }

//   void _onMapCreated(GoogleMapController _cntlr) {
//     _controller = _controller;
//     location.onLocationChanged.listen((l) {
//       _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/images/start_page.jpeg'),
//               fit: BoxFit.cover),
//         ),
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: SafeArea(
//           child: Container(
//             color: Colors.blueGrey.withOpacity(.8),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.9,
//                     width: MediaQuery.of(context).size.width,
//                     child: GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                           target: _initialcameraposition, zoom: 15),
//                       mapType: MapType.normal,
//                       onMapCreated: _onMapCreated,
//                       MapPageEnabled: true,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   if (_currentPosition != null)
//                     Text(
//                       "Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}",
//                       style: TextStyle(
//                           fontSize: 22,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   if (_address != null)
//                     Text(
//                       "Address: $_address",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   getLoc() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _currentPosition = await location.getLocation();
//     _initialcameraposition =
//         LatLng(_currentPosition.latitude, _currentPosition.longitude);
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       print("${currentLocation.longitude} : ${currentLocation.longitude}");
//       setState(() {
//         _currentPosition = currentLocation;
//         _initialcameraposition =
//             LatLng(_currentPosition.latitude, _currentPosition.longitude);
//         _getAddress(_currentPosition.latitude, _currentPosition.longitude)
//             .then((value) {
//           setState(() {
//             _address = "${value.first.addressLine}";
//           });
//         });
//       });
//     });
//   }

//   Future<List<Address>> _getAddress(double lat, double lang) async {
//     final coordinates = new Coordinates(lat, lang);
//     List<Address> add =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     return add;
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

import 'UserHome.dart';

String _address = "Searching Location ...";
List<Marker> myMarker = [];

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocationData _currentPosition;
  Marker marker;
  Location location = Location();

  GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(19.0473, 73.0699);

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(19.0473, 73.0699), zoom: 14),
            // onMapCreated: onMapCreated,
            onTap: _handleTap,
            markers: Set.from(myMarker),
            mapType: MapType.hybrid,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text("DONE"),
              )),
        ],
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true));
      print(tappedPoint);
      getLoc();
    });
  }

  void onMapCreated(controller) {
    setState(() {
      _controller = controller;
    });
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
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        _getAddress(_currentPosition.latitude, _currentPosition.longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}
