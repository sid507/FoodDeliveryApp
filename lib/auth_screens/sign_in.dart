import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_delivery_app/auth_screens/sign_up.dart';
import 'package:food_delivery_app/backend/auth.dart';
import 'package:food_delivery_app/backend/database.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phoneController = TextEditingController();
  bool phoneError = false;
  bool clickedOnSignIn = false;
  bool validation() {
    if (_phoneController.text.length < 10 || _phoneController.text == null) {
      phoneError = true;
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    print(totalWidth);
    double totalHeight = MediaQuery.of(context).size.height;
    print(totalHeight);
    double defaultFontSize = totalHeight * 14 / 700;
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
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: totalHeight * 0.2,
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
                  clickedOnSignIn
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF785B))),
                        )
                      : Container(),
                  SizedBox(
                    height: totalHeight * 8 / 700,
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
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      onPressed: () async {
                        if (!validation()) {
                          setState(() {}); // set state to show error messages
                        } else {
                          // first check in cloud firestore whether user is registered
                          bool userExist = await Database().userExists(
                              context, "+91" + _phoneController.text);
                          if (userExist == true) {
                            // if user exists then we perform OTP verification
                            setState(() => clickedOnSignIn = true);
                            await Auth().phoneNumberVerificationLogin(
                                "+91" + _phoneController.text, context);
                            setState(() => clickedOnSignIn = false);
                          } else {
                            AlertMessage().showAlertDialog(context, "Error!",
                                "You are not a registered user! You can register on the Sign Up page");
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: totalHeight * 1 / 700,
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
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: defaultFontSize,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        )
                      },
                      child: Container(
                        child: Text(
                          "Sign Up",
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
