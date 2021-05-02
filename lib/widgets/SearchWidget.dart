import 'package:flutter/material.dart';
import '../user/ScaleRoute.dart';
import '../user/SearchPage.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    TextEditingController searchController = new TextEditingController();
    String searchText;
    bool _validate = false;
    return Padding(
      padding: EdgeInsets.only(
          left: totalWidth * 10 / 420,
          right: totalWidth * 5 / 420,
          top: totalHeight * 10 / 700,
          bottom: totalHeight * 5 / 700),
      child: TextFormField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(
                  width: 0,
                  color: Colors.indigoAccent[100],
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              // prefixIcon: Icon(
              //   Icons.search,
              //   color: Colors.indigoAccent[100],
              // ),
              fillColor: Color(0xFFFAFAFA),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                color: Colors.indigoAccent[100],
                onPressed: () {
                  searchText = searchController.text;
                  searchText.isEmpty ? _validate = true : _validate = false;
                  if (_validate == false)
                    Navigator.push(context,
                        ScaleRoute(page: SearchPage(searchText: searchText)));
                },
              ),
              hintStyle: new TextStyle(
                  color: Color(0xFFd0cece), fontSize: totalHeight * 16 / 700),
              hintText: "What would your like to eat?"),
          onFieldSubmitted: (searchText) {
            if (searchText == "") {
              _validate = true;
            } else
              Navigator.push(context,
                  ScaleRoute(page: SearchPage(searchText: searchText)));
          }),
    );
  }
}
