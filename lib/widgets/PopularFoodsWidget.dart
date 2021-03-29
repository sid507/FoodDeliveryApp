import 'package:flutter/material.dart';

import '../user/ScaleRoute.dart';
import '../user/FoodDetailsPage.dart';

class PopularFoodsWidget extends StatefulWidget {
  @override
  _PopularFoodsWidgetState createState() => _PopularFoodsWidgetState();
}

class _PopularFoodsWidgetState extends State<PopularFoodsWidget> {
  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      height: totalHeight * 315 / 700,
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

class PopularFoodTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String rating;
  String numberOfRating;
  String price;
  String slug;

  PopularFoodTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.numberOfRating,
      @required this.price,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(context, ScaleRoute(page: FoodDetailsPage()));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: totalWidth * 10 / 420,
                right: totalWidth * 5 / 420,
                top: totalHeight * 1 / 700,
                bottom: totalHeight * 1 / 700),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: totalWidth * 190 / 420,
                  height: totalHeight * 200 / 700,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                width: totalWidth * 28 / 420,
                                height: totalHeight * 28 / 700,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFdee8ff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFdee8ff),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.favorite,
                                  color: Color(0xFFfb3132),
                                  size: totalHeight * 16 / 700,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Image.asset(
                              'assets/images/' + imageUrl,
                              width: totalWidth * 110 / 420,
                              height: totalHeight * 100 / 700,
                            )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(
                                left: totalWidth * 5 / 420,
                                top: totalHeight * 5 / 700),
                            child: Text(name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: totalHeight * 15 / 700,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding:
                                EdgeInsets.only(right: totalWidth * 5 / 420),
                            child: Container(
                              height: totalHeight * 28 / 420,
                              width: totalWidth * 28 / 420,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFdee8ff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFdee8ff),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                              child: Icon(
                                Icons.near_me,
                                color: Color(0xFFfb3132),
                                size: totalHeight * 16 / 700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    left: totalWidth * 5 / 420,
                                    top: totalHeight * 5 / 700),
                                child: Text(rating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: totalHeight * 10 / 700,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: totalHeight * 3 / 700,
                                    left: totalWidth * 5 / 420),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      size: totalHeight * 10 / 700,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: totalHeight * 10 / 700,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: totalHeight * 10 / 700,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: totalHeight * 10 / 700,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: totalHeight * 10 / 700,
                                      color: Color(0xFF9b9b9c),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                    left: totalWidth * 5 / 420,
                                    top: totalHeight * 5 / 700),
                                child: Text("($numberOfRating)",
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: totalHeight * 10 / 700,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(
                                left: totalWidth * 5 / 420,
                                top: totalHeight * 5 / 700,
                                right: totalWidth * 5 / 420),
                            child: Text('\Rs. ' + price,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: totalHeight * 12 / 700,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
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
            "Popular Foods",
            style: TextStyle(
                fontSize: totalHeight * 20 / 700,
                color: Color(0xFF002140),
                fontWeight: FontWeight.bold),
          ),
          Text(
            "See all",
            style: TextStyle(
                fontSize: totalHeight * 16 / 700,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class PopularFoodItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        PopularFoodTiles(
            name: "Paneer Tikka",
            imageUrl: "panner_tikka.JPG",
            rating: '4.9',
            numberOfRating: '200',
            price: '250',
            slug: ""),
        PopularFoodTiles(
            name: "Mixed Vegetable",
            imageUrl: "popular_foods/ic_popular_food_3.png",
            rating: "4.9",
            numberOfRating: "100",
            price: "150",
            slug: ""),
        PopularFoodTiles(
            name: "Dosa",
            imageUrl: "dosa.jpg",
            rating: "4.0",
            numberOfRating: "50",
            price: "50",
            slug: ""),
        PopularFoodTiles(
            name: "Mixed Salad",
            imageUrl: "popular_foods/ic_popular_food_5.png",
            rating: "4.00",
            numberOfRating: "10",
            price: "100",
            slug: ""),
        PopularFoodTiles(
            name: "Gujarati Thali",
            imageUrl: "topmenu/west_indian.png",
            rating: "4.6",
            numberOfRating: "50",
            price: "300",
            slug: ""),
        PopularFoodTiles(
            name: "Momos",
            imageUrl: "topmenu/north_east_indian.jpg",
            rating: "4.2",
            numberOfRating: "70",
            price: "80",
            slug: ""),
        PopularFoodTiles(
            name: "Fried Egg",
            imageUrl: "popular_foods/ic_popular_food_1.png",
            rating: '4.9',
            numberOfRating: '200',
            price: '40',
            slug: "fried_egg"),
      ],
    );
  }
}
