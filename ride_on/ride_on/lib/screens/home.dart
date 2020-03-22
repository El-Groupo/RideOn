import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_pages/login_signup_page.dart';
import '../login_pages/root_page.dart';
import '../services/authentication.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../singleton.dart';
import 'history.dart';
import '../accountMenu.dart';

class MyHomePage extends StatefulWidget
{

  MyHomePage({Key key, this.title, /*this.app,*/ this.auth, this.userId, this.logoutCallback}) : super(key: key)
  {
    theSingleton = Singleton();
    theSingleton.setAuth(auth);
    theSingleton.setLogoutCallback(logoutCallback);
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
//  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference rideData = FirebaseDatabase.instance.reference().child("ride");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static bool _isRecording = false;
  static var currRide;// = new RideObject();
  static double maxSpeed = 0.0;
  var location = new Location();
  static LocationData userLocation;
  static String myToy = "big red";
  Timer _everySecond; //recording frequency timer

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller)
  {
    mapController = controller;
  }

  static Set<Polyline> _routes = new Set<Polyline>();
  static int num = 0;

  saveData()
  {
    rideData.push().set({
      'userId': 'currRide.getUserID()',
      'maxSpeed': currRide.maxSpeed,
      'rideLength': currRide.rideLength,
      'rideTimeSec': currRide.rideTimeSec,
      'rideRoute': currRide.rideRoute,
      'rideDate': currRide.rideDate,
      'vehiclename': currRide.vehicleName,
    });
  }

  void grabData()
  {
    Query rideQuery = rideData.orderByChild("userId").equalTo(widget.userId);
    //rideQuery.
  }

  void addRide(RideObject rideIn)
  {
    num+= 10;
    var latlngList = List<LatLng>();

//    for(int i = 0; i < 100; i++)
//      {
//        latlngList.add(LatLng(40.2444845 + (i)/10000, -111.6474918 + (i+2*num)*(i+num)/1000000));
//      }

    for(int i = 0; i < rideIn.rideRoute.length; i++)
    {
      latlngList.add(rideIn.rideRoute[i]);
    }

    var tempLine= new Polyline(
        polylineId: PolylineId(DateTime.now().toIso8601String()),
        points:latlngList,
        color: Colors.blue,//[(100 + num * 10) % 500],  //for some reason, this gives an error after a few seconds
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        width: 5
    );

    Set<Polyline> tempSet = Set<Polyline>();
    tempSet.add(tempLine);

//    if(_routes.isNotEmpty) {
//      tempSet.add(_routes.last.copyWith(
//          colorParam: Colors.blue)); //add it to the temp set with final color
//      _routes.remove(_routes.last);
//      _routes.
//    }
    _routes = _routes.union(tempSet);


   rideData.push().set(currRide.toJson());
    mySingleton.addRide(currRide);
  }

  void _toggleRecording()
  {
    setState(()
    {
      if(!_isRecording)
      {
        _isRecording = true;
        location = new Location();
        currRide = new RideObject();
        currRide.setDate(DateTime.now());
        currRide.setName(myToy);
        currRide.setUserID(widget.userId);
      }
      else if(_isRecording){
        _isRecording = false;
        //HistoryRoute.saveRide(currRide);
        addRide(currRide);
        //saveData();
        //_database.reference().child("Ride").push().set(currRide.toJson());
        //handleSubmit();
        //put it on the database
      }
    });
  }

  void _getLocation(Stream<LocationData> stream) async
  {
    try {
      await for(LocationData value in stream)
        {
          currRide.setMax(value.speed);
          currRide.addPoint(
              LatLng(value.latitude, value.longitude));
          userLocation = value;
          //location.getLocation();
        }
    }
    catch (e){
//      userLocation = null;
    }

    //return currentLocation;
  }

  Future<LocationData> _getCurrLocation() async
  {
    LocationData currentLocation;

    try
    {
      currentLocation = await location.getLocation();
    }
    catch (e)
    {
      currentLocation = null;
    }

    return currentLocation;
  }

  void updateScreen()
  {
    setState(()
      {
      if(_isRecording)
      {
        _getLocation(location.onLocationChanged());
        //.then(() {
          //userLocation = value;
        //});
        currRide.incRideTime();
        currRide.addDistance(userLocation.speed);
      }
    });
  }

  signOut() async {
    try {
      await mySingleton.auth.signOut();
      mySingleton.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  /*
  void handleSubmit()
  {
    final FormState form = formKey.currentState;
    if (form.validate())
      {
        form.save();
        form.reset();
        itemRef.push().set(currRide.toJson());
      }
  }

   */

  @override
  void initState()
  {
    super.initState();
    //itemRef = FirebaseDatabase.instance.reference().child('Rides');

    //_getCurrLocation();


    // defines a timer
    /*_everySecond = */Timer.periodic(Duration(seconds: 1), (Timer t)
    {
      if(_isRecording) updateScreen();
    });
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
            return HamburgerMenu();//.setUser("user.data.uid", "user.data.email");
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
            Container(
              constraints: BoxConstraints.expand(
                width: 350,                           //FIXME - Magic number
                height: 500,                          //FIXME - Magic number
              ),
              decoration: BoxDecoration(color: Colors.blue[200]),
              child: FutureBuilder(
                future: _getCurrLocation(),
                builder: (context, AsyncSnapshot<LocationData> currLoc) {
                  var displayLoc;
                  if (currLoc.hasData) {
                    displayLoc = LatLng(currLoc.data.latitude, currLoc.data.longitude);
                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      mapType: MapType.hybrid,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: displayLoc,
                        //LatLng(40.2463985, -111.6541483),
//                      (userLocation == null ? 40.2463985 : userLocation.latitude),         FIXED??
//                      (userLocation == null ? -111.6541483 : userLocation.longitude)       FIXED??

                        zoom: 17.0,
                      ),
                      polylines: _routes,
                    );
                  }
                  else {
                    return Text("Loading...");
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Current Speed\n' +
                          ((userLocation != null && _isRecording) ?
                          mpsTomph(userLocation.speed).toStringAsFixed(2) + ' mph' : ''
                          ),
                    ),
//                    if(_isRecording) Text(mpsTomph(userLocation.speed).toStringAsFixed(2) + ' mph'),
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: ()
                      {
                        setState(()
                        {
                          _toggleRecording();
                        });
                      },
                      tooltip: 'Begin Recording',
                      //child: Icon(Icons.),
                    ),
                    Text(
                      _isRecording ? 'Recording\n'+ currRide.rideTimeSec.toString() + 's' : 'Record',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Top Speed\n' +
                          (_isRecording ? currRide.maxSpeed.toStringAsFixed(1) : '--') +
                          ' mph',
                        textAlign: TextAlign.center,
                    ),

                    Text(
                      'Avg Speed\n' +
                          (_isRecording ? currRide.getAvgSpeed().toStringAsFixed(1) : '--') +
                          ' mph',
                      textAlign: TextAlign.center,
                    ),
                  ]
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}


