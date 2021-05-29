import 'package:flutter/material.dart';
// import 'package:food_delivery_app/user/UserHome.dart';

import 'UserHome.dart';
import 'Menucard.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/start_page.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(totalWidth * 10 / 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Image.asset("assets/images/start_page.jpeg"),
                SizedBox(
                  height: totalHeight * 120 / 700,
                ),
                Text(
                  "Hi, nice to meet you!",
                  style: TextStyle(
                      fontFamily: "Robonto",
                      fontWeight: FontWeight.bold,
                      fontSize: totalHeight * 30 / 700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: totalHeight * 10 / 700,
                ),
                Text(
                  "Set your location to start exploring restaurants around you",
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: "Robonto",
                      fontWeight: FontWeight.normal,
                      fontSize: totalHeight * 25 / 700),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   "restaurants around you",
                //   style: TextStyle(
                //       fontFamily: "Robonto",
                //       fontWeight: FontWeight.normal,
                //       fontSize: totalHeight * 25 / 700),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(
                  height: totalHeight * 30 / 700,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuOptionSide(
                          automatic: true,
                          address: "Searching Location ...",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(totalHeight * 10 / 700)),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.add_location_sharp,
                              size: totalHeight * 20 / 700),
                        ),
                        TextSpan(
                          text: " Use Current Location",
                          style: TextStyle(
                              fontSize: totalHeight * 20 / 700,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: totalHeight * 15 / 700,
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
                        borderRadius:
                            BorderRadius.circular(totalHeight * 10 / 700)),
                  ),
                  child: Text(
                    "Set Your Location Manually",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: totalHeight * 20 / 700,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: totalHeight * 100 / 700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
