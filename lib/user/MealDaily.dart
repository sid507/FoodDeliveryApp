import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Cart.dart';
import 'package:food_delivery_app/user/EatDaily.dart';
import 'Utils.dart';

class MealDaily extends StatefulWidget {
  @override
  _MealDailyState createState() => _MealDailyState();
}

class _MealDailyState extends State<MealDaily> {
  // Helper help=new Helper();
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Outline_button(
                    "06 : 00AM - 11:00AM", Icons.breakfast_dining)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Outline_button("01 : 00PM - 03:00PM", Icons.wb_sunny),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Outline_button("07 : 00PM - 09:00PM", Icons.dinner_dining),
            ),
          ],
        ),
      ),
    );
  }

  Widget Outline_button(String time, IconData icon) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (!states.contains(MaterialState.pressed))
              return Helper().button.withOpacity(1);
            return null; // Use the component's default.
          },
        ),
      ),
      onPressed: () {
        // Respond to button press
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodOrderPage(),
          ),
        );
      },
      label: Text(
        time,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
      icon: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
