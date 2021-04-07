import 'package:food_delivery_app/my_account_page/task.dart';
import 'package:flutter/material.dart';

List<Task> tasks = [
  new Task(
      name: "Pizza",
      category: "Dinner",
      time: "8pm",
      color: Colors.orange,
      completed: false),
  new Task(
      name: "Dosa",
      category: "Breakfast",
      time: "11am",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Ragda Pattice",
      category: "Breakfast",
      time: "9am",
      color: Colors.pink,
      completed: false),
  new Task(
      name: "Pasta",
      category: "Dinner",
      time: "9pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Roti Dal",
      category: "Lunch",
      time: "1pm",
      color: Colors.cyan,
      completed: true),
];
