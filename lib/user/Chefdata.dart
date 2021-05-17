import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chef {
  String id;
  String name;
  dynamic rating;
  Chef(String name, dynamic rating, String id) {
    this.name = name;
    this.rating = rating;
    this.id = id;
  }
}

class Dishes extends Chef {
  String _dishname;
  dynamic _price;
  dynamic _rating;
  String _image;
  String _time;
  String _mealType;
  int _count;
  Dishes(String id, String name, dynamic rating, String dishname, dynamic price,
      String image, String time, String mealType, int count)
      : super(name, rating, id) {
    this._dishname = dishname;
    this._price = price;
    this._rating = rating;
    this._image = image;
    this._time = time;
    this._mealType = mealType;
    this._count = count;
  }
  String getDishName() {
    return this._dishname;
  }

  String getMealType() {
    return this._mealType;
  }

  dynamic getPrice() {
    return this._price;
  }

  int getCount() {
    return this._count;
  }

  dynamic getRating() {
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

  dynamic calculateTotal(List<SingleCartItem> dishe) {
    dynamic price = 0;
    for (int i = 0; i < dishe.length; i++) {
      price += dishe[i].quantity * dishe[i].dish.getPrice();
    }
    return price;
  }

  dynamic calculateGrandTotal() {
    dynamic price = this.calculateTotal(dishes);
    return price > 0 ? (price + 50) : 0;
  }
}

class EatNowData {
  List<Dishes> data = [];
  List<String> d = [];
  EatNowData() {
    // Dishes d1 = new Dishes("Siddharth Mishra", 4.5, "Paneer Tikka", 250,
    //     "panner_tikka.JPG", "25 min", "Lunch", 5);
    // Dishes d2 = new Dishes("Nishant Pal", 4.7, "Dosa", 250, "dosa.jpg",
    //     "30 mins", "Breakfast", 10);
    // this.data.add(d1);
    // this.data.add(d2);
    // this.data.add(d2);

    final db = FirebaseFirestore.instance;
    var chef = new Map();
    CollectionReference collectionReference = db.collection('Chef');
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
