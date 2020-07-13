import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_on/objects/vehicleObject.dart';

import '../services/authentication.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../singleton.dart';
import '../accountMenu.dart';
import 'Home/bottomBar.dart';
import 'Home/mapDisplay.dart';

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
            MapDisplay(),
//            Container(
//              constraints: BoxConstraints.expand(
//                width: MediaQuery.of(context).size.width*.95,
//                height: MediaQuery.of(context).size.height-200,
//              ),
//              decoration: BoxDecoration(color: Colors.blue[200]),
//              child: FutureBuilder(
//                future: _getCurrLocation(),
//                builder: (context, AsyncSnapshot<LocationData> currLoc) {
////                  var displayLoc;
//                  if (currLoc.hasData) {
//                    displayLoc = LatLng(currLoc.data.latitude, currLoc.data.longitude);
//                    return GoogleMap(
//                      onMapCreated: _onMapCreated,
//                      mapType: MapType.hybrid,
//                      myLocationEnabled: true,
//                      initialCameraPosition: CameraPosition(
//                        target: displayLoc,
//                        //LatLng(40.2463985, -111.6541483),
////                      (userLocation == null ? 40.2463985 : userLocation.latitude),         FIXED??
////                      (userLocation == null ? -111.6541483 : userLocation.longitude)       FIXED??
//
//                        zoom: 17.0,
//                      ),
//                      polylines: _routes,
//                    );
//                  }
//                  else {
//                    return Text(
//                      "Loading...",
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                        fontSize: 30,
//                      ),
//                    );
//                  }
//                },
//              ),
//            ),
            BottomBar(),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    SelectableText(
//                      displayCurrentVehicle(),
//                       onTap: () {
//                        showSelectVehicle(context);
//                      },
//                    ),
//                    Text(
//                      'Current Speed\n' +
//                          ((userLocation != null && _isRecording) ?
//                          mpsTomph(userLocation.speed).toStringAsFixed(2) + ' mph' : ''
//                          ),
//                    ),
////                    if(_isRecording) Text(mpsTomph(userLocation.speed).toStringAsFixed(2) + ' mph'),
//                  ]
//                ),
////                RecordButton(),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    FloatingActionButton(
//                      onPressed: ()
//                      {
//                        setState(()
//                        {
//                          _toggleRecording();
//                        });
//                      },
//                      tooltip: 'Begin Recording',
//                      //child: Icon(Icons.),
//                    ),
//                    Text(
//                      _isRecording ? 'Recording\n'+ currRide.rideTimeSec.toString() + 's' : 'Record',
//                      textAlign: TextAlign.center,
//                    ),
//                  ],
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      'Top Speed\n' +
//                          (_isRecording ? currRide.maxSpeed.toStringAsFixed(1) : '--') +
//                          ' mph',
//                        textAlign: TextAlign.center,
//                    ),
//
//                    Text(
//                      'Avg Speed\n' +
//                          (_isRecording ? currRide.getAvgSpeed().toStringAsFixed(1) : '--') +
//                          ' mph',
//                      textAlign: TextAlign.center,
//                    ),
//                  ]
//                )
//              ]
//            ),
          ],
        ),
      ),
    );
  }

//  String displayCurrentVehicle()
//  {
//    String nickname = "vehicle not selected";
//    for (VehicleObject vehicleObject in mySingleton.getToys())
//    {
//        if (vehicleObject.isCurrentVehicle) {
//          currRide.setVehicleWithObject(vehicleObject);
//          nickname = vehicleObject.getNickname();
//          currVehicle = vehicleObject;
//        }
//    }
//    return nickname;
//  }
//
//  void setCurrentVehicle(VehicleObject vehicle)
//  {
//    for (VehicleObject aVehicle in mySingleton.getToys())
//    {
//      if (aVehicle.getNickname() == vehicle.getNickname()) {
//        currRide.setVehicleWithObject(vehicle);
//        aVehicle.setIsCurrentVehicle(true);
//        currVehicle = aVehicle;
//      }
//      else {
//        aVehicle.setIsCurrentVehicle(false);
//      }
//      vehicleRef.child(aVehicle.key).set(aVehicle.toJson());
//    }
//  }



////Stuff for adding a vehicle, taken from the garage
//  final nameController = TextEditingController();
//  final dateController = TextEditingController();
//  DateTime newPurchaseDate;
//  String newToyNickname = "";
//  VehicleType newToyType;

//  showSelectVehicle(BuildContext context) async
//  {
//    await showDialog<String>(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: new Text("Select your vehicle"),
//          content: Container(
//            width: double.maxFinite,
//            child: SingleChildScrollView(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  ListView.builder(
//                    shrinkWrap: true,
//                    itemCount: mySingleton.getToys().length,
//                    itemBuilder: getListItemTile,
//                  ),
//                  SelectableText(
//                    'Add vehicle',
//                    onTap: () {
//                      showAddVehicleDialog(context);
//                    },
//                  )
//                ]
//              ),
//            ),
//          ),
//        );
//      }
//    );
//  }

//  Widget getListItemTile(BuildContext context, int index)
//  {
//    return GestureDetector(
//      onTap: () {
//        setState(() {
//          currRide.setVehicleWithObject(mySingleton.getToys()[index]);
//          currRide.setName(mySingleton.getToys()[index].getNickname());
//          setCurrentVehicle(mySingleton.getToys()[index]);
//        });
//        Navigator.pop(context);
//      },
//
//      child: Container(
//        margin: EdgeInsets.symmetric(vertical: 4),
//        color: Colors.white,
//        child: ListTile(
//          title: Text(mySingleton.getToys()[index].getNickname()),
//        ),
//      ),
//    );
//  }

//  showAddVehicleDialog(BuildContext context) async
//  {
//    nameController.clear();
//    dateController.clear();
//    await showDialog<String>(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//              title: new Text("Add New Vehicle"),
//              content: Column(
//                children: <Widget>[
//                  TextFormField(
//                    controller: nameController,
//                    autofocus: true,
//                    decoration: new InputDecoration(
//                      labelText: "Vehicle Name",
//                    ),
//                  ),
//                  TextFormField(
//                    controller: dateController,
//                    autofocus: true,
//                    decoration: new InputDecoration(
//                      labelText: "Purchase date yyyy-mm-dd",
//                    ),
//                  ),
//                  DropdownButton(
//                    hint: Text('Please select vehicle type'),
//                    value: newToyType,
//                    onChanged: (newValue) {
//                      setState(() {
//                        newToyType = newValue;
//                      });
//                    },
//                    items: VehicleType.values.map((type) {
//                      return DropdownMenuItem(
//                        child: new Text(printVehicleType(type)),
//                        value: type,
//                      );
//                    }).toList(),
//                  )
//                ],
//              ),
//              actions: <Widget>[
//                new FlatButton(
//                    child: const Text('Cancel'),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    }),
//                new FlatButton(
//                    child: const Text('Save'),
//                    onPressed: () {
//                      addNewVehicle(nameController.text.toString(), dateController.text.toString());
//                      Navigator.pop(context);
//                    }),
//              ]
//          );
//        });
//  }

//  String printVehicleType(VehicleType type) {
//    String vehicleType = "";
//    switch(type)
//    {
//      case VehicleType.motorcycle:
//        vehicleType += "Motorcycle";
//        break;
//      case VehicleType.fourWheeler:
//        vehicleType += "4 Wheeler";
//        break;
//      case VehicleType.utv:
//        vehicleType += "UTV";
//        break;
//      case VehicleType.other:
//        vehicleType += "Other";
//        break;
//    }
//    return vehicleType;
//  }

//  void addNewVehicle(String name, String date)
//  {
//    VehicleObject newVehicle = new VehicleObject();
//    newVehicle.setNickname(name);
//    newVehicle.setPurchaseDate(parseDate(date));
//    newVehicle.setEnumType(newToyType);
//    newVehicle.setTopSpeed(0.0);
//    newVehicle.setTotalHours(0.0);
//    newVehicle.setUserId(mySingleton.userID);
//    vehicleRef.push().set(newVehicle.toJson());
//    newVehicle.getCreatedKey();
//    setCurrentVehicle(newVehicle);
//    currVehicle = newVehicle;
//    mySingleton.addToy(newVehicle);
//    mySingleton.sortToys();
//  }
}


