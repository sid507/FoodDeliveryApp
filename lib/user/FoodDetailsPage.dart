import 'package:flutter/material.dart';
import 'ScaleRoute.dart';
import 'Cart.dart';

class FoodDetailsPage extends StatefulWidget {
  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.business_center,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {
                  Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                })
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: totalWidth * 15 / 420,
            right: totalWidth * 15 / 420,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(
                  'assets/images/panner_tikka.JPG',
                  width: totalWidth * 200 / 420,
                  height: totalHeight * 2 / 7,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                elevation: 1,
                margin: EdgeInsets.all(totalHeight * 5 / 700),
              ),
              /*  Container(
                height: totalHeight*150/700,
                child:FoodDetailsSlider(
                    slideImage1: "assets/images/bestfood/ic_best_food_8.jpeg",
                    slideImage2: "assets/images/bestfood/ic_best_food_9.jpeg",
                    slideImage3: "assets/images/bestfood/ic_best_food_10.jpeg"),
              ),*/

              FoodTitleWidget(
                  productName: "Paneer Tikka",
                  productPrice: "\Rs. 250.00",
                  productHost: "The Punjabi Dhaba"),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              AddToCartMenu(),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(
                  totalHeight * 50 / 700,
                ),
                child: TabBar(
                  labelColor: Color(0xFFfd3f40),
                  indicatorColor: Color(0xFFfd3f40),
                  unselectedLabelColor: Color(0xFFa4a1a1),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: 'Food Details',
                    ),
                    Tab(
                      text: 'Food Reviews',
                    ),
                  ], // list of tabs
                ),
              ),
              Container(
                height: totalHeight * 100 / 700,
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.white24,
                      child: DetailContentMenu(),
                    ),
                    Container(
                      color: Colors.white24,
                      child: DetailContentMenu(),
                    ), // class name
                  ],
                ),
              ),
              BottomMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodTitleWidget extends StatelessWidget {
  String productName;
  String productPrice;
  String productHost;

  FoodTitleWidget({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: TextStyle(
                  fontSize: totalHeight * 20 / 700,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              productPrice,
              style: TextStyle(
                  fontSize: totalHeight * 20 / 700,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: totalHeight * 5 / 700,
        ),
        Row(
          children: <Widget>[
            Text(
              "by ",
              style: TextStyle(
                  fontSize: totalHeight * 16 / 700,
                  color: Color(0xFF002140),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              productHost,
              style: TextStyle(
                  fontSize: totalHeight * 16 / 700,
                  color: Color(0xFF1f1f1f),
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.timelapse,
                color: Color(0xFF404aff),
                size: totalHeight * 35 / 700,
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Text(
                "12pm-3pm",
                style: TextStyle(
                    fontSize: totalHeight * 15 / 700,
                    color: Color(0xFF002140),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions,
                color: Color(0xFF23c58a),
                size: totalHeight * 35 / 700,
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Text(
                "3.5 km",
                style: TextStyle(
                    fontSize: totalHeight * 15 / 700,
                    color: Color(0xFF002140),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.map,
                color: Color(0xFFff0654),
                size: totalHeight * 35 / 700,
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Text(
                "Map View",
                style: TextStyle(
                    fontSize: totalHeight * 15 / 700,
                    color: Color(0xFF002140),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_bike,
                color: Color(0xFFe95959),
                size: totalHeight * 35 / 700,
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Text(
                "Delivery",
                style: TextStyle(
                    fontSize: totalHeight * 15 / 700,
                    color: Color(0xFF002140),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: totalHeight * 30 / 700,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
            },
            child: Container(
              width: totalWidth * 200 / 420,
              height: totalHeight * 45 / 700,
              decoration: new BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(
                  color: Colors.white,
                  width: totalWidth * 2 / 420,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Add To Bag',
                  style: new TextStyle(
                      fontSize: totalHeight * 18 / 700,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: totalHeight * 30 / 700,
          ),
        ],
      ),
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Text(
        'Paneer Tikka',
        style: TextStyle(
            fontSize: totalHeight * 14 / 700,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            height: totalHeight * 1.5 / 700),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
