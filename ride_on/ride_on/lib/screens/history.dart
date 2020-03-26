import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ride_on/singleton.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../services/authentication.dart';


TextStyle tableHeader()
{
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic,
  );
}

TextStyle tableData()
{
  return TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
  );
}

class HistoryRoute extends StatefulWidget
{
  HistoryRoute({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HistoryRouteState();
}

class _HistoryRouteState extends State<HistoryRoute>
{
  var mySingleton = Singleton();
  List<RideObject> rideHistory = List();

  @override
  void initState()
  {
    super.initState();
    rideHistory = mySingleton.getRides();

  }

  Widget showRideList() {

    if (rideHistory.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: rideHistory.length,
          itemBuilder: (BuildContext context, int index) {
            String rideId = rideHistory[index].key;
            DateTime rideDate = rideHistory[index].rideDate;
            String vehicleName = rideHistory[index].vehicleName;
            String userId = rideHistory[index].userId;
            int rideDuration = rideHistory[index].rideTimeSec;
            double maxSpeed = rideHistory[index].maxSpeed;
            return Dismissible(
              key: Key(rideId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                //deleteTodo(todoId, index);
              },
              child: ListTile(

                leading: FlutterLogo(size: 56.0),
                title: Text(vehicleName),
                subtitle: Text(
                    maxSpeed.toString() + " mph | " + rideDuration.toString() +
                        " seconds riding"),
                trailing: Icon(Icons.more_vert),

              ),
            );
          });
    } else {
      return Center(
          child: Text(
            "Welcome. Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Rides'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        drawer: HamburgerMenu(),
        body: showRideList(),
    );

  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

}