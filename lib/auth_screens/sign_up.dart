import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';
import 'package:food_delivery_app/backend/auth.dart';
import 'package:food_delivery_app/backend/database.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String _role = 'User';
  bool fnameError = false;
  bool lnameError = false;
  bool phoneError = false;
  bool clickedOnSignUp = false;

  bool validation() {
    bool retVal = true;
    if (_fnameController.text == "" || _fnameController.text == null) {
      fnameError = true;
      retVal = false;
    }
    if (_lnameController.text == "" || _lnameController.text == null) {
      lnameError = true;
      retVal = false;
    }
    if (_phoneController.text.length < 10 || _phoneController.text == null) {
      phoneError = true;
      retVal = false;
    }
    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double defaultFontSize = totalWidth * 15 / 420;
    double defaultIconSize = totalHeight * 17 / 700;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(
            left: totalWidth * 2 / 40,
            right: totalWidth * 2 / 40,
            top: totalHeight * 35 / 700,
            bottom: totalHeight * 30 / 700),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: totalHeight * 0.15,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _fnameController,
                          showCursor: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: defaultFontSize,
                              ),
                              hintText: "First Name",
                              errorText: fnameError
                                  ? "Please enter first name"
                                  : null),
                        ),
                      ),
                      SizedBox(
                        width: totalWidth * 10 / 420,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _lnameController,
                          showCursor: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: defaultFontSize,
                              ),
                              hintText: "Last Name",
                              errorText:
                                  lnameError ? "Please enter last name" : null),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: totalHeight * 15 / 700,
                  ),
                  SizedBox(
                    height: totalHeight * 15 / 700,
                  ),
                  TextField(
                    maxLength: 10,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: defaultFontSize),
                        hintText: "Phone Number",
                        errorText:
                            phoneError ? "Enter a valid phone number" : null),
                  ),
                  SizedBox(
                    height: totalHeight * 15 / 700,
                  ),
                  clickedOnSignUp
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF785B))),
                        )
                      : Container(),
                  SizedBox(
                    height: totalHeight * 15 / 700,
                  ),
                  Container(
                    width: 0.3 * totalWidth,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFFfbab66),
                        ),
                        BoxShadow(
                          color: Color(0xFFf7418c),
                        ),
                      ],
                      gradient: new LinearGradient(
                          colors: [Color(0xFFf7418c), Color(0xFFfbab66)],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Color(0xFFf7418c),
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: Text("Sign Up",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 16)),
                      ),
                      onPressed: () async {
                        // first check in cloud firestore whether user is registered
                        if (!validation()) {
                          setState(() {});
                        } else {
                          bool userExist = await Database().userExists(
                              context, "+91" + _phoneController.text);
                          if (userExist == false) {
                            // we perform OTP verification only if it is a new user
                            setState(() => clickedOnSignUp = true);
                            await Auth().phoneNumberVerificationRegister(
                                "+91" + _phoneController.text,
                                _fnameController.text,
                                _lnameController.text,
                                _role,
                                context);
                            setState(() => clickedOnSignUp = false);
                          } else {
                            AlertMessage().showAlertDialog(context, "Error",
                                "A user with this phone number already exists!");
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: defaultFontSize,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Container(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color(0xFFf7418c),
                            fontSize: defaultFontSize,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
