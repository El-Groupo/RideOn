import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ride_on/objects/vehicleObject.dart';
import 'package:ride_on/services/authentication.dart';
import 'package:ride_on/hamburgerMenu.dart';
import 'package:ride_on/objects/rideObject.dart';
import 'package:ride_on/singleton.dart';
import 'package:ride_on/accountMenu.dart';
import 'package:ride_on/screens/Home/mapDisplay.dart';
import 'package:ride_on/screens/Home/bottomBar.dart';


class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title, this.auth, this.userId, this.logoutCallback}) : super(key: key)
  {
    theSingleton = Singleton();
    theSingleton.setAuth(auth);
    theSingleton.setLogoutCallback(logoutCallback);
    theSingleton.userID = userId;
  }

  var theSingleton;
  final String title;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  var mySingleton = Singleton();
  _MyHomePageState({this.user});

  final FirebaseUser user;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference vehicleRef = FirebaseDatabase.instance.reference().child("vehicle");
  static Set<Polyline> _routes = new Set<Polyline>();

  void updateScreen()
  {
    setState(()
      {
        if(mySingleton.isRecording)
        {
          mySingleton.getLocation(mySingleton.location.onLocationChanged());
          mySingleton.currRide.incRideTime();
          mySingleton.currRide.addDistance(mySingleton.userLocation.speed);
          mySingleton.displayLoc = LatLng(mySingleton.userLocation.latitude, mySingleton.userLocation.longitude);
        }
      }
    );
  }

  @override
  void initState()
  {
    super.initState();
    //mySingleton.setEmail(user.data.email);
    mySingleton.setUserID(widget.userId);
    mySingleton.myRides.clear();
    DatabaseReference rideRef = FirebaseDatabase.instance.reference().child("ride");
    rideRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      for (var individualKey in KEYS)
        {
          String userID =  DATA[individualKey]['userId'];
          if(userID == widget.userId) {
            RideObject newRide = new RideObject();

            newRide.setUserID(userID);
            newRide.key = individualKey;
            String date = DATA[individualKey]['rideDate'];
            DateTime myDate = parseDate(date);
            newRide.setDate(myDate);
            double mySpeed = 0;
            try {
              int speed = DATA[individualKey]['maxSpeed'];
              mySpeed = speed.toDouble();
            }
            catch (Exception){
              mySpeed = DATA[individualKey]['maxSpeed'];
            }
            newRide.setMaxSpeed(mySpeed);
            double myLength = 0;
            try {
              int length = DATA[individualKey]['rideLength'];
              myLength = length.toDouble();
            }
            catch (Exception) {
              myLength = DATA[individualKey]['rideLength'];
            }
            newRide.setRideLength(myLength);
            String name = DATA[individualKey]['vehiclename'];
            newRide.setName(name);
            int time = DATA[individualKey]['rideTimeSec'];
            newRide.setRideTime(time);
            List<dynamic> route = DATA[individualKey]['rideRouteDoubles'];
            List<double> myRoute = route.map((s) => s as double).toList();
            newRide.setRideRouteDoubles(myRoute);
            newRide.setVehicleFromDatabase();
            mySingleton.addRide(newRide);
          }

        }
    });

    vehicleRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      for (var key in KEYS)
        {
          String userID = DATA[key]['userId'];
          if(userID == widget.userId) {
            VehicleObject newVehicle = new VehicleObject();

            newVehicle.setUserId(userID);
            newVehicle.key = key;
            String purchDate = DATA[key]['purchaseDate'];
            newVehicle.setPurchaseDate(parseDate(purchDate));
            double allTimeTopSpeed = 0;
            try {
              int speed = DATA[key]['allTimeTopSpeed'];
              allTimeTopSpeed = speed.toDouble();
            }
            catch (Exception) {
              allTimeTopSpeed = DATA[key]['allTimeTopSpeed'];
            }
            newVehicle.setTopSpeed(allTimeTopSpeed);
            double totalHours = 0;
            try {
              int hours = DATA[key]['totalVehicleHours'];
              totalHours = hours.toDouble();
            }
            catch (Exception){
              totalHours = DATA[key]['totalVehicleHours'];
            }
            newVehicle.setTotalHours(totalHours);
            String nickname = DATA[key]['toyNickname'];
            newVehicle.setNickname(nickname);
            String toyType = DATA[key]['toyType'];
            newVehicle.setType(toyType);
            String isCurrent = DATA[key]['isCurrentVehicle'];
            if (isCurrent == "true") {
              newVehicle.setIsCurrentVehicle(true);
              mySingleton.currRide.setVehicleWithObject(newVehicle);
              mySingleton.currVehicle = newVehicle;
            }
            else {
              newVehicle.setIsCurrentVehicle(false);
            }
            mySingleton.addToy(newVehicle);
          }
        }
    });

    // defines a timer
    Timer.periodic(Duration(seconds: 1), (Timer t)
    {
      if(mySingleton.isRecording) updateScreen();
    });

    mySingleton.sortRides();
    mySingleton.sortToys();
  }

  //2020-03-21 16:56:46.95467...

  DateTime parseDate(String date)
  {
    String year = date.substring(0,4);
    String month = date.substring(5,7);
    String day = date.substring(8,10);
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          AccountMenu(),
        ],
      ),
      drawer: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> user) {
          if (user.hasData) {
            mySingleton.setEmail(user.data.email);
            mySingleton.setUserID(user.data.uid);
            return HamburgerMenu();
          }
          else {
            return Text('Loading...');
          }
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MapDisplay(),
            BottomBar(),
          ],
        ),
      ),
    );
  }
}


