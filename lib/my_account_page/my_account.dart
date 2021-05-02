import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_delivery_app/my_account_page/animated_fab.dart';
import 'package:food_delivery_app/my_account_page/diagonal_clipper.dart';
import 'package:food_delivery_app/my_account_page/initial_list.dart';
import 'package:food_delivery_app/my_account_page/list_model.dart';
import 'package:food_delivery_app/my_account_page/task_row.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);

  @override
  _MyAccountState createState() => new _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  ListModel listModel;
  bool showOnlyCompleted = false;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, tasks);
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    double height = totalHeight * 1 / 3;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildImage(height),
          _buildTopHeader(height),
          _buildProfileRow(height),
          _buildBottomPart(height),
          // _buildFab(height, totalWidth),
        ],
      ),
    );
  }

  Widget _buildFab(double height, double totalWidth) {
    return new Positioned(
      top: height - height * 1 / 3,
      right: totalWidth * 1 / 3,
      child: new AnimatedFab(
        onClick: _changeFilterState,
      ),
    );
  }

  void _changeFilterState() {
    showOnlyCompleted = !showOnlyCompleted;
    tasks.where((task) => !task.completed).forEach((task) {
      if (showOnlyCompleted) {
        listModel.removeAt(listModel.indexOf(task));
      } else {
        listModel.insert(tasks.indexOf(task), task);
      }
    });
  }

  Widget _buildImage(double height) {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'assets/images/drawer_header_background.png',
          fit: BoxFit.cover,
          height: height,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }

  Widget _buildTopHeader(double height) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "My Account",
                style: new TextStyle(
                    fontSize: height / 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          new IconButton(
            icon: Icon(Icons.login),
            color: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(double height) {
    final User user = auth.currentUser;
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: height / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundImage: new AssetImage('assets/images/dp.png'),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "My Number",
                      style: new TextStyle(
                          fontSize: height / 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    // Text(
                    //   'Edit',
                    //   textAlign: TextAlign.right,
                    //   style: new TextStyle(
                    //       fontSize: height / 16.0,
                    //       color: Colors.yellow,
                    //       fontWeight: FontWeight.w400),
                    // ),
                  ],
                ),
                new Text(
                  user.phoneNumber,
                  style: new TextStyle(
                      fontSize: height / 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPart(double height) {
    return new Padding(
      padding: new EdgeInsets.only(top: height),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(height),
          // _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: tasks.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskRow(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildMyTasksHeader(double height) {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'My Orders',
            style: new TextStyle(fontSize: height / 16.0),
          ),
          // new Text(
          //   '5 April, 2021',
          //   style: new TextStyle(color: Colors.grey, fontSize: height / 18.0),
          // ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }
}
