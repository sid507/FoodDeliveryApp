import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/user/EmptyCart.dart';
import 'package:food_delivery_app/user/Utils.dart';

class FoodOrderPage extends StatefulWidget {
  final String address;
  FoodOrderPage({Key key, this.address}) : super(key: key);
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 3;
  List<SingleCartItem> dishes;
  Helper help = new Helper();
  dynamic totalCost = 0;

  @override
  void initState() {
    dishes = CartData().getItem();
    dishes.where((element) => element.quantity != 0);
    print(dishes);
    totalCost = CartData().calculateTotal(dishes);
    super.initState();
  }

  void deleteItem(int quantity) => {
        setState(() {
          quantity = 0;
        })
      };

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Helper().background,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Item Carts",
            style:
                TextStyle(color: Helper().heading, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: dishes.length > 0
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Your Food Cart",
                        style: TextStyle(
                            fontSize: totalHeight * 20 / 700,
                            color: Helper().heading,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: totalHeight * 10 / 700,
                    ),
                    ListView(
                        shrinkWrap: true,
                        children: dishes.map((data) {
                          // print(data);

                          return CartItem(
                              productName: data.dish.getDishName(),
                              productPrice: data.dish.getPrice().toString(),
                              productImage: data.dish.getimage(),
                              productCartQuantity: data.quantity.toString(),
                              delItem: () {
                                setState(() => {
                                      dishes.removeWhere((element) =>
                                          element.dish.getDishName() ==
                                              data.dish.getDishName() &&
                                          element.dish.name == data.dish.name),
                                    });
                                totalCost = CartData().calculateTotal(dishes);
                                print(data.dish.getDishName());
                              },
                              deliveryTime: data.dish.gettime(),
                              addItem: () {
                                setState(() => {
                                      data.quantity = Helper().addQuantity(
                                        data.quantity,
                                      )
                                    });
                              },
                              removeItem: () {
                                setState(() => {
                                      data.quantity = Helper().delQuantity(
                                        data.quantity,
                                      )
                                    });
                              },
                              updateCost: () {
                                setState(() {
                                  totalCost = CartData().calculateTotal(dishes);
                                });
                              });
                        }).toList()),
                    PromoCodeWidget(),
                    SizedBox(
                      height: totalHeight * 10 / 700,
                    ),
                    TotalCalculationWidget(totalCost),
                    SizedBox(
                      height: totalHeight * 10 / 700,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Payment Method",
                        style: TextStyle(
                            fontSize: totalHeight * 20 / 700,
                            color: Color(0xFF3a3a3b),
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: totalHeight * 10 / 700,
                    ),
                    PaymentMethodWidget(),
                    SizedBox(
                      height: totalHeight * 5 / 700,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            totalWidth * 0.2,
                            totalHeight * 0.02,
                            totalWidth * 0.2,
                            totalHeight * 0.02),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              uploadOrderToFirebase(dishes);
                            },
                            child: Text(
                              'Place Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: totalWidth * 0.06),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                primary: Color(0xFFFF785B)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : EmptyShoppingCartScreen(),
    );
  }

  final orders = FirebaseFirestore.instance.collection('Orders');

  void uploadOrderToFirebase(List<SingleCartItem> dishes) {
    addOrder(dishes);
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Success",
        description: "Order Placed Successfully ! Delicious Food en route",
        buttonText: "Okay",
      ),
    );
  }

  Future<void> addOrder(List<SingleCartItem> dishes) {
    List<String> productName = [],
        deliveryTime = [],
        productPrice = [],
        productCartQuantity = [];

    String chefId = "";
    double totalCost;
    print("dishes = $dishes");

    List order = dishes.map((data) {
      productName.add(data.dish.getDishName());
      productPrice.add(data.dish.getPrice().toString());
      productCartQuantity.add(data.quantity.toString());
      deliveryTime.add(data.dish.gettime());
      chefId = data.dish.getChefId();
      totalCost = CartData().calculateGrandTotal();
    }).toList();

    // for (int i = 0; i < dishes.length; i++)
    // print(
    //     "Order = $productName $productPrice $productCartQuantity $deliveryTime $totalCost\n");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm d MMM').format(now);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    String userId = user.uid;
    String phone = user.phoneNumber;

    return orders
        .add({
          "dishName": productName,
          "pricePerServing": productPrice,
          "quantity": productCartQuantity,
          "totalCost": totalCost,
          "isDelivered": false,
          "timeOrderPlaced": formattedDate,
          "address": widget.address,
          "chefId": chefId,
          "userId": userId,
          "userPhone": phone,
          "rating": "",
          "feedback": ""
        })
        .then(
          (value) => print("Order Uploaded on Firestore"),
        )
        .catchError(
          (error) => print("Failed to add Order: $error"),
        );
  }
}

class CustomDialog extends StatelessWidget {
  static const double padding = 4.0;
  static const double avatarRadius = 11.0;
  final String title, description, buttonText;
  final Image image;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: totalHeight * 5.0 / 100,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: totalHeight * 10.0 / 100),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: totalHeight * 3.0 / 100,
                ),
              ),
              SizedBox(height: totalHeight * 10.0 / 100),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: avatarRadius,
            child: Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: totalHeight * 60 / 700,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: totalWidth * 10 / 420,
              right: totalWidth * 30 / 420,
              top: totalHeight * 10 / 700,
              bottom: totalHeight * 10 / 700),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Icon(Icons.credit_card),
              ),
              Text(
                "Credit/Debit Card",
                style: TextStyle(
                    fontSize: totalHeight * 16 / 700,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatefulWidget {
  double totalCost;
  TotalCalculationWidget(this.totalCost);
  @override
  _TotalCalculationWidgetState createState() => _TotalCalculationWidgetState();
}

class _TotalCalculationWidgetState extends State<TotalCalculationWidget> {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: totalHeight * 150 / 700,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: totalWidth * 25 / 420,
              right: totalWidth * 30 / 420,
              top: totalHeight * 10 / 700,
              bottom: totalHeight * 10 / 700),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Item Total",
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.totalCost.toString(),
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Delivery Charge",
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "50Rs",
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: totalHeight * 15 / 700,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Grand Total",
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    CartData().calculateGrandTotal().toString(),
                    style: TextStyle(
                        fontSize: totalHeight * 18 / 700,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
            left: totalWidth * 3 / 420, right: totalWidth * 3 / 420),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ]),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Colors.white,
              hintText: 'Add Your Promo Code',
              filled: true,
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.local_offer,
                    color: Color(0xFFfd2c2c),
                  ),
                  onPressed: () {
                    debugPrint('222');
                  })),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  String productName;
  String productPrice;
  String productImage;
  String productCartQuantity;
  String deliveryTime;
  Function delItem;
  Function updateCost, addItem, removeItem;
  CartItem(
      {Key key,
      @required this.productName,
      @required this.productPrice,
      @required this.productImage,
      @required this.productCartQuantity,
      @required this.delItem,
      @required this.deliveryTime,
      @required this.updateCost,
      @required this.addItem,
      @required this.removeItem})
      : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Card(
        color: Helper().card,
        // color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Padding(
          // alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: totalWidth * 10 / 420,
              right: totalWidth * 10 / 420,
              top: totalHeight * 10 / 700,
              bottom: totalHeight * 10 / 700),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.productImage,
                      ),
                      fit: BoxFit.cover),
                ),
                height: totalHeight * 80 / 700,
                width: totalWidth * 120 / 420,
                // child: Image.network(
                //   widget.productImage,
                //   height: totalHeight * 80 / 700,
                //   width: totalWidth * 130 / 420,
                //   // image: Image.network(),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${widget.productName}",
                              style: TextStyle(
                                  fontSize: totalHeight * 16 / 700,
                                  color: Helper().heading,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                            // SizedBox(
                            //   height: totalHeight * 5 / 700,
                            // ),
                            Text(
                              widget.deliveryTime != '0'
                                  ? "${widget.productPrice}"
                                  : "Subscription",
                              style: TextStyle(
                                  fontSize: totalHeight * 12 / 700,
                                  color: Helper().normalText,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                            widget.deliveryTime != '0'
                                ? Text(
                                    "Delivery :${widget.deliveryTime}",
                                    style: TextStyle(
                                        fontSize: totalHeight * 12 / 700,
                                        color: Helper().normalText,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  )
                                : new Container(width: 0.0, height: 0.0),
                          ],
                        ),
                        SizedBox(
                          width: totalWidth * 30 / 420,
                        ),
                        Container(
                          // alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => {widget.delItem()}),
                        )
                      ],
                    ),
                    widget.deliveryTime != '0'
                        ? Container(
                            alignment: Alignment.centerRight,
                            child: AddToCartMenu(
                                int.parse(widget.productCartQuantity),
                                widget.updateCost,
                                widget.addItem,
                                widget.removeItem),
                          )
                        : new Container(width: 0.0, height: 0.0)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CartIconWithBadge extends StatelessWidget {
  int counter = 3;

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {}),
        counter != 0
            ? Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: totalWidth * 14 / 700,
                    minHeight: totalHeight * 14 / 700,
                  ),
                  child: Text(
                    '$counter',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: totalHeight * 8 / 700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatefulWidget {
  int productCounter;
  Function updateCost, addItem, removeItem;
  AddToCartMenu(
      this.productCounter, this.updateCost, this.addItem, this.removeItem);

  @override
  _AddToCartMenuState createState() => _AddToCartMenuState();
}

class _AddToCartMenuState extends State<AddToCartMenu> {
  Helper helper = new Helper();

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () => {
              setState(
                () => {
                  widget.removeItem(),
                  widget.updateCost(),
                },
              )
            },
            icon: Icon(Icons.remove_circle),
            color: Helper().button,
            iconSize: totalHeight * 28 / 700,
          ),
          InkWell(
            onTap: () => print('hello'),
            child: Container(
              width: totalWidth * 60 / 420,
              height: totalHeight * 35 / 700,
              decoration: BoxDecoration(
                color: Helper().button,
                // border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Add To ${widget.productCounter}',
                  style: new TextStyle(
                      fontSize: totalHeight * 12 / 700,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.addItem();
              widget.updateCost();
            },
            icon: Icon(Icons.add_circle),
            color: Helper().button,
            iconSize: totalHeight * 28 / 700,
          ),
        ],
      ),
    );
  }
}
