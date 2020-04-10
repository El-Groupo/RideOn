import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ride_on/objects/vehicleObject.dart';
import 'package:ride_on/screens/ride.dart';
import 'package:ride_on/singleton.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../services/authentication.dart';
import '../accountMenu.dart';


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

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  Query rideQuery;
  StreamSubscription<Event> _onRideAddedSubscription;
  StreamSubscription<Event> _onRideChangedSubscription;
  
  @override
  void initState()
  {
    super.initState();
    rideHistory = mySingleton.getRides();
    /*
    rideQuery = _database.reference().child("Ride")
        .orderByChild("AssociatedUsername")
        .equalTo(widget.userId);
    _onRideAddedSubscription = rideQuery.onChildAdded.listen(onEntryAdded);
    _onRideChangedSubscription =
        rideQuery.onChildAdded.listen(onEntryChanged);

     */
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

  }

  Widget showRideList()
  {

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
            VehicleType toyType = rideHistory[index].myVehicle.toyType;
            String icon;
            if (toyType == VehicleType.motorcycle) {
              icon = "lib/media/images/dirtbike.PNG";
            }
            else if (toyType == VehicleType.fourWheeler) {
              icon = "lib/media/images/4wheeler.PNG";
            }
            else if (toyType == VehicleType.utv) {
              icon = "lib/media/images/utv.PNG";
            }
            else {
              icon = "lib/media/images/dirtbike.PNG";
            }
            return Dismissible(
              key: Key(rideId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                //deleteTodo(todoId, index);
              },
              child: ListTile(

                leading: Image.asset(icon),
                title: Text(vehicleName),
                subtitle: Text(
                    maxSpeed.toStringAsFixed(2) + " mph | " + rideDuration.toString() +
                        " seconds riding"),
                trailing: Icon(Icons.more_vert),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RideRoute(rideHistory[index])),
                  );
                },

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
    return Scaffold(
        appBar: new AppBar(
          title: new Text('My Rides'),
          actions: <Widget>[
            AccountMenu(),
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