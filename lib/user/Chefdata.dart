import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chef {
  String name;
  double rating;
  Chef(String name, double rating) {
    this.name = name;
    this.rating = rating;
  }
}

class Dishes extends Chef {
  String _dishname;
  double _price;
  double _rating;
  String _image;
  String _time;
  String _mealType;
  Dishes(String name, double rating, String dishname, double price,
      String image, String time, String mealType)
      : super(name, rating) {
    this._dishname = dishname;
    this._price = price;
    this._rating = rating;
    this._image = image;
    this._time = time;
    this._mealType = mealType;
  }
  String getDishName() {
    return this._dishname;
  }

  String getMealType() {
    return this._mealType;
  }

  double getPrice() {
    return this._price;
  }

  double getRating() {
    if (this._rating != null)
      return this._rating;
    else
      return 4.5;
  }

  String getimage() {
    return this._image;
  }

  String gettime() {
    return this._time;
  }
}

class SingleCartItem {
  Dishes dish;
  int quantity;
  SingleCartItem(Dishes dish, int quantity) {
    this.dish = dish;
    this.quantity = quantity;
  }
}

class CartData {
  static List<SingleCartItem> dishes = [];

  void addItem(Dishes dish, int quantity) {
    dishes.add(SingleCartItem(dish, quantity));
  }

  List<SingleCartItem> getItem() {
    return dishes;
  }

  double calculateTotal(List<SingleCartItem> dishe) {
    double price = 0;
    for (int i = 0; i < dishe.length; i++) {
      price += dishe[i].quantity * dishe[i].dish.getPrice();
    }
    return price;
  }

  double calculateGrandTotal() {
    double price = this.calculateTotal(dishes);
    return price > 0 ? (price + 50) : 0;
  }
}

class EatNowData {
  List<Dishes> data = [];
  List<String> d = [];
  EatNowData() {
    Dishes d1 = new Dishes("Siddharth Mishra", 4.5, "Paneer Tikka", 250,
        "panner_tikka.JPG", "25 min", "Lunch");
    Dishes d2 = new Dishes(
        "Nishant Pal", 4.7, "Dosa", 250, "dosa.jpg", "30 mins", "Breakfast");
    this.data.add(d1);
    this.data.add(d2);
    this.data.add(d2);

    final db = FirebaseFirestore.instance;
    var chef = new Map();
    CollectionReference collectionReference = db.collection('Chefs');
    collectionReference.snapshots().listen((snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        chef[snapshot.docs[i].id] = snapshot.docs[i].data();
        // print(snapshot.docs[i].id);
        // this.d.add(snapshot.docs[i].id);
      }
    });
    print(this.d);

    // print(this.data.toString() + 'sid');
  }
  List<Dishes> getData() {
    return this.data;
  }
}
