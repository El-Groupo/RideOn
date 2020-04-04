import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_on/objects/vehicleObject.dart';

import '../login_pages/login_signup_page.dart';
import '../login_pages/root_page.dart';
import '../services/authentication.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../singleton.dart';
import 'history.dart';

class MyHomePage extends StatefulWidget
{

  MyHomePage({Key key, this.title, /*this.app,*/ this.auth, this.userId, this.logoutCallback}) : super(key: key);

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
  //final FirebaseDatabase _database = FirebaseDatabase.instance;
  final DatabaseReference rideData = FirebaseDatabase.instance.reference().child("ride");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static bool _isRecording = false;
  RideObject currRide = new RideObject();
  VehicleObject currVehicle = new VehicleObject();
  static double maxSpeed = 0.0;
  var location = new Location();
  static LocationData userLocation;
  LatLng currentLocation;
  //static String myToy = "big red";
  Timer _everySecond; //recording frequency timer
  DatabaseReference vehicleRef = FirebaseDatabase.instance.reference().child("vehicle");




  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller)
  {
    mapController = controller;
  }

  static Set<Polyline> _routes = new Set<Polyline>();
  static int num = 0;

  void addRide(RideObject rideIn)
  {
   //stuff for ride object
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
        polylineId: PolylineId('steven' + num.toString()),
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

    //stuff for updating a vehicle
    currVehicle.adjustTopSpeed(maxSpeed);
    currVehicle.adjustHours(currRide.getRideTime());
    currVehicle.adjustMiles(currRide.getDistance());
    vehicleRef.child(currVehicle.key).set(currVehicle.toJson());
    currRide = new RideObject();
    currRide.setVehicleWithObject(currVehicle);
  }

  void _toggleRecording()
  {
    setState(()
    {
      if(!_isRecording)
      {
        _isRecording = true;
        location = new Location();
        //currRide = new RideObject();
        currRide.setDate(DateTime.now());
        currRide.setVehicleWithObject(currVehicle);

        currRide.setName(currRide.myVehicle.getNickname());
        currRide.setUserID(widget.userId);
      }
      else if(_isRecording){
        _isRecording = false;
        addRide(currRide);
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
      mySingleton.clearSingleton();
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState()
  {
    super.initState();
    //mySingleton.setEmail(user.data.email)
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
              currRide.setVehicleWithObject(newVehicle);
              currVehicle = newVehicle;
            }
            else {
              newVehicle.setIsCurrentVehicle(false);
            }
            mySingleton.addToy(newVehicle);
          }
        }
    });
    //_getCurrLocation();


    // defines a timer
    /*_everySecond = */Timer.periodic(Duration(seconds: 1), (Timer t)
    {
      if(_isRecording) updateScreen();
    });
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
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut,
          )
        ],
      ),
      drawer: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> user) {
          if (user.hasData) {
            return HamburgerMenu.setUser("user.data.displayName", user.data.email);
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
                  }
                  else {
                    displayLoc = LatLng(40.2463985, -111.6541483);
                  }
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: displayLoc,
                      //LatLng(40.2463985, -111.6541483),
//                      (userLocation == null ? 40.2463985 : userLocation.latitude),         FIXED??
//                      (userLocation == null ? -111.6541483 : userLocation.longitude)       FIXED??

                      zoom: 17.0,
                    ),
                    polylines: _routes,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SelectableText(
                      displayCurrentVehicle(),
                      onTap: () {
                        showSelectVehicle(context);
                      },
                    ),
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

  String displayCurrentVehicle()
  {
    String nickname = "vehicle not selected";
    for (VehicleObject vehicleObject in mySingleton.getToys())
    {
        if (vehicleObject.isCurrentVehicle) {
          currRide.setVehicleWithObject(vehicleObject);
          nickname = vehicleObject.getNickname();
          currVehicle = vehicleObject;
        }
    }
    return nickname;
  }

  void setCurrentVehicle(VehicleObject vehicle)
  {
    for (VehicleObject aVehicle in mySingleton.getToys())
    {
      if (aVehicle.getNickname() == vehicle.getNickname()) {
        currRide.setVehicleWithObject(vehicle);
        aVehicle.setIsCurrentVehicle(true);
        currVehicle = aVehicle;
      }
      else {
        aVehicle.setIsCurrentVehicle(false);
      }
      vehicleRef.child(aVehicle.key).set(aVehicle.toJson());
    }
  }



//Stuff for adding a vehicle, taken from the garage
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  DateTime newPurchaseDate;
  String newToyNickname = "";
  VehicleType newToyType;

  showSelectVehicle(BuildContext context) async
  {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select your vehicle"),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: mySingleton.getToys().length,
                    itemBuilder: getListItemTile,
                  ),
                  SelectableText(
                    'Add vehicle',
                    onTap: () {
                      showAddVehicleDialog(context);
                    },
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
  }

  Widget getListItemTile(BuildContext context, int index)
  {
    return GestureDetector(
      onTap: () {
        setState(() {
          currRide.setVehicleWithObject(mySingleton.getToys()[index]);
          currRide.setName(mySingleton.getToys()[index].getNickname());
          setCurrentVehicle(mySingleton.getToys()[index]);
        });
      },

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Colors.white,
        child: ListTile(
          title: Text(mySingleton.getToys()[index].getNickname()),
        ),
      ),
    );
  }

  showAddVehicleDialog(BuildContext context) async
  {
    nameController.clear();
    dateController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Add New Vehicle"),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: "Vehicle Name",
                    ),
                  ),
                  TextFormField(
                    controller: dateController,
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: "Purchase date yyyy-mm-dd",
                    ),
                  ),
                  DropdownButton(
                    hint: Text('Please select vehicle type'),
                    value: newToyType,
                    onChanged: (newValue) {
                      setState(() {
                        newToyType = newValue;
                      });
                    },
                    items: VehicleType.values.map((type) {
                      return DropdownMenuItem(
                        child: new Text(printVehicleType(type)),
                        value: type,
                      );
                    }).toList(),
                  )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('Save'),
                    onPressed: () {
                      addNewVehicle(nameController.text.toString(), dateController.text.toString());
                      Navigator.pop(context);
                    }),
              ]
          );
        });
  }

  String printVehicleType(VehicleType type) {
    String vehicleType = "";
    switch(type)
    {
      case VehicleType.motorcycle:
        vehicleType += "Motorcycle";
        break;
      case VehicleType.fourWheeler:
        vehicleType += "4 Wheeler";
        break;
      case VehicleType.utv:
        vehicleType += "UTV";
        break;
      case VehicleType.other:
        vehicleType += "Other";
        break;
    }
    return vehicleType;
  }

  void addNewVehicle(String name, String date)
  {
    VehicleObject newVehicle = new VehicleObject();
    newVehicle.setNickname(name);
    newVehicle.setPurchaseDate(parseDate(date));
    newVehicle.setEnumType(newToyType);
    newVehicle.setTopSpeed(0.0);
    newVehicle.setTotalHours(0.0);
    newVehicle.setUserId(mySingleton.userID);
    vehicleRef.push().set(newVehicle.toJson());
    newVehicle.getCreatedKey();
    setCurrentVehicle(newVehicle);
    currVehicle = newVehicle;
    mySingleton.addToy(newVehicle);
  }
}


