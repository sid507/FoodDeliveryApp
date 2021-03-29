import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          left: totalWidth * 10 / 420,
          right: totalWidth * 5 / 420,
          top: totalHeight * 10 / 700,
          bottom: totalHeight * 5 / 700),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 0,
              color: Colors.indigoAccent[100],
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.indigoAccent[100],
          ),
          fillColor: Color(0xFFFAFAFA),
          suffixIcon: Icon(
            Icons.sort,
            color: Colors.indigoAccent[100],
          ),
          hintStyle: new TextStyle(
              color: Color(0xFFd0cece), fontSize: totalHeight * 16 / 700),
          hintText: "What would your like to eat?",
        ),
      ),
    );
  }
}
