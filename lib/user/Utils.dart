import 'package:flutter/material.dart';

class Helper {
  Color background = Color.fromRGBO(247, 247, 248, 1);
  Color card = Color(0xFFDEE8FF);
  Color heading = Color(0xFF002140);
  Color button = Color(0xFFFF785B);
  Color normalText = Color.fromRGBO(87, 92, 112, 1);
  Color top = Color.fromRGBO(48, 47, 54, 1);
  int addQuantity(int quantity) {
    return ++quantity;
  }

  int delQuantity(int quantity) {
    if (quantity > 1) {
      return --quantity;
    } else {
      return 1;
    }
  }
}

class Constant {}
