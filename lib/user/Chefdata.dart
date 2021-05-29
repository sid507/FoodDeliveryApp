import 'package:cloud_firestore/cloud_firestore.dart';

class Chef {
  String name;
  String chefAddress;
  dynamic rating;
  Chef(String name, String chefAddress, dynamic rating) {
    this.name = name;
    this.chefAddress = chefAddress;
    this.rating = rating;
  }
}

class Dishes extends Chef {
  String _dishname;
  bool _self_delivery;
  String _chefId;
  dynamic _price;
  dynamic _rating;
  String _image;
  String _time;
  String _toTime;
  String _fromTime;
  String _selectedDate;
  String _mealType;
  int _count;
  Dishes(
      String name,
      String chefAddress,
      dynamic rating,
      String dishname,
      bool self_delivery,
      dynamic price,
      String image,
      String time,
      String mealType,
      int count,
      String chefId,
      String toTime,
      String fromTime,
      String selectedDate)
      : super(name, chefAddress, rating) {
    this._dishname = dishname;
    this._self_delivery = self_delivery;
    this._price = price;
    this._rating = rating;
    this._image = image;
    this._time = time;
    this._mealType = mealType;
    this._count = count;
    this._chefId = chefId;
    this._toTime = toTime;
    this._fromTime = fromTime;
    this._selectedDate = selectedDate;
  }
  String getDishName() {
    return this._dishname;
  }

  bool getSelfDelivery() {
    return this._self_delivery;
  }

  String getChefId() {
    return this._chefId;
  }

  String getMealType() {
    return this._mealType;
  }

  String getToTime() {
    return this._toTime;
  }

  String getFromTime() {
    return this._fromTime;
  }

  String getSelectedDate() {
    return this._selectedDate;
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
    final db = FirebaseFirestore.instance;
    var chef = new Map();
    CollectionReference collectionReference = db.collection('Chef');
    collectionReference.snapshots().listen((snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        chef[snapshot.docs[i].id] = snapshot.docs[i].data();
      }
    });
    print(this.d);
  }
  List<Dishes> getData() {
    return this.data;
  }
}
