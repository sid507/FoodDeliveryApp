import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/user/EmptyCart.dart';
import 'package:food_delivery_app/user/Utils.dart';

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 3;
  List<SingleCartItem> dishes;
  Helper help = new Helper();
  double totalCost = 0;

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
              style: TextStyle(
                  color: Helper().heading, fontWeight: FontWeight.bold),
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
                                            data.dish.getDishName()),
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
                                    totalCost =
                                        CartData().calculateTotal(dishes);
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
                    ],
                  ),
                ),
              )
            : EmptyShoppingCartScreen());
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
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: totalHeight * 18 / 700,
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
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: totalHeight * 18 / 700,
          ),
        ],
      ),
    );
  }
}
