import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  List<RideObject> rideHistory = List();
  var newRideHistory = List<RideObject>();

  void saveRide(RideObject newRide)
  {
    newRideHistory.add(newRide);
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  Query rideQuery;
  StreamSubscription<Event> _onRideAddedSubscription;
  StreamSubscription<Event> _onRideChangedSubscription;
  
  @override
  void initState()
  {
    super.initState();
    rideHistory = new List();
    rideQuery = _database.reference().child("Ride")
        .orderByChild("AssociatedUsername")
        .equalTo(widget.userId);
    _onRideAddedSubscription = rideQuery.onChildAdded.listen(onEntryAdded);
    _onRideChangedSubscription =
        rideQuery.onChildAdded.listen(onEntryChanged);
  }

  onEntryAdded(Event event) {
    setState(() {
      rideHistory.add(RideObject.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    var oldEntry = rideHistory.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      rideHistory[rideHistory.indexOf(oldEntry)] =
          RideObject.fromSnapshot(event.snapshot);
    });
  }

  @override
  void dispose() {
    _onRideAddedSubscription.cancel();
    _onRideChangedSubscription.cancel();
    super.dispose();
  }

  addNewRide(RideObject rideItem) {
    if (RideObject != null) {
      _database.reference().child("Ride").push().set(rideItem.toJson());
    }
  }

  /*
  updateRide(RideO todo) {
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

   */
/*
  deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

 */

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
          title: new Text('my Rides'),
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



//  Widget generateHistoryTableRow(RideObject rideIn)
//  {
//    return TableRow(
//      children: <Widget>[
//        Text(rideIn.rideDate.toIso8601String(),
//          style: tableData(),
//        ),
//        Text('\tVehicle Name',
//          style: tableData(),
//        ),
//        Text(rideIn.rideTimeSec.toString(),
//          style: tableData(),
//        ),
//        Text('\tyote',
//          style: tableData(),
//        ),
//      ],
//    ),
//
//    );
//  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
          children: <Widget>[
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(),
                verticalInside: BorderSide(),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: FlexColumnWidth(100),
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
//                    border: Border(
//                      bottom: BorderSide(),
//                      right: BorderSide(),
//                    ),
                  ),
                  children: <Widget>[
                    Text('\tRide Date',
                        style: tableHeader(),
                    ),
                    Text('\tVehicle Name',
                      style: tableHeader(),
                    ),
                    Text('\tRide Duration',
                      style: tableHeader(),
                    ),
                    Text('\tYeet',
                      style: tableHeader(),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Text('\tLike Yesterday',
                        style: tableData(),
                    ),
                    Text('\tBig Red',
                      style: tableData(),
                    ),
                    Text('\t45 seconds',
                      style: tableData(),
                    ),
                    Text('\tyeet',
                      style: tableData(),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Text('\t27 BC',
                      style: tableData(),
                    ),
                    Text('\tFlinstone Car',
                      style: tableData(),
                    ),
                    Text('\t7 days',
                      style: tableData(),
                    ),
                    Text('\tyaga',
                      style: tableData(),
                    ),
//                    generateHistoryTableRow(rideHistory[0]),
                  ],
                ),
                if(newRideHistory.length >= 1) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[0].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[0].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[0].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 2) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[1].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[1].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[1].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 3) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[2].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[2].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[2].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 4) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[3].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[3].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[3].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 5) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[4].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[4].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[4].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 6) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[5].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[5].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[5].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 7) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[6].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[6].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[6].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 8) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[7].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[7].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[7].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 9) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[8].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[8].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[8].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 10) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[9].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[9].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[9].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }

 */
}