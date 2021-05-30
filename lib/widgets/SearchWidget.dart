import 'package:flutter/material.dart';
import 'package:food_delivery_app/user/Chefdata.dart';
import 'package:food_delivery_app/user/Utils.dart';
import '../user/ScaleRoute.dart';
import '../user/SearchPage.dart';

class SearchWidget extends StatelessWidget {
  String address;
  Function refreshCartNumber;
  SearchWidget(this.refreshCartNumber, this.address);
  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    TextEditingController searchController = new TextEditingController();
    String searchText;
    bool _validate = false;
    return Padding(
      padding: EdgeInsets.only(
          left: totalWidth * 5 / 420,
          right: totalWidth * 5 / 420,
          top: totalHeight * 5 / 700,
          bottom: totalHeight * 5 / 700),
      child: TextFormField(
          cursorColor: Colors.deepOrange,
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: new InputDecoration(
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: new BorderSide(
                  width: 1,
                  color: Helper().button,
                  // style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Helper().button, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Helper().button, width: 1.0),
              ),
              filled: true,
              // prefixIcon: Icon(
              //   Icons.search,
              //   color: Colors.indigoAccent[100],
              // ),
              fillColor: Color(0xFFFAFAFA),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                color: Helper().button,
                onPressed: () {
                  searchText = searchController.text;
                  searchText.isEmpty ? _validate = true : _validate = false;
                  if (_validate == false)
                    Navigator.push(
                        context,
                        ScaleRoute(
                            page: SearchPage(
                                address: address,
                                refreshCartNumber: refreshCartNumber,
                                searchText: searchText)));
                },
              ),
              hintStyle: new TextStyle(
                  color: Color(0xFFd0cece), fontSize: totalHeight * 16 / 700),
              hintText: "What would your like to eat?"),
          onFieldSubmitted: (searchText) {
            if (searchText == "") {
              _validate = true;
            } else
              Navigator.push(
                  context,
                  ScaleRoute(
                      page: SearchPage(
                          address: address,
                          refreshCartNumber: refreshCartNumber,
                          searchText: searchText)));
          }),
    );
  }
}
