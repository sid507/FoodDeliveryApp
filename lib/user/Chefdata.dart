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
  String _image;
  String _time;
  Dishes(String name, double rating, String dishname, double price,
      String image, String time)
      : super(name, rating) {
    this._dishname = dishname;
    this._price = price;
    this._image = image;
    this._time = time;
  }
  String getDishName() {
    return this._dishname;
  }

  double getPrice() {
    return this._price;
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
  static List<SingleCartItem> dishes = [
    SingleCartItem(
        Dishes("Siddharth Mishra", 4.5, "Paneer Tikka", 250, "panner_tikka.JPG",
            "25 min"),
        2)
  ];

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
  EatNowData() {
    Dishes d1 = new Dishes("Siddharth Mishra", 4.5, "Paneer Tikka", 250,
        "panner_tikka.JPG", "25 min");
    Dishes d2 =
        new Dishes("Nishant Pal", 4.7, "Dosa", 250, "dosa.jpg", "30 mins");
    this.data.add(d1);
    this.data.add(d2);
    this.data.add(d2);
    // print(this.data.toString() + 'sid');
  }
  List<Dishes> getData() {
    return this.data;
  }
}
