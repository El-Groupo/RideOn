import 'package:flutter/material.dart';
import 'dart:async';

import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'hamburgerMenu.dart';
import 'objects/rideObject.dart';
import 'screens/history.dart';


void main() => runApp(MyApp());

Map<int, Color> color =
{
 50:Color.fromRGBO(136,14,79, .1),
100:Color.fromRGBO(136,14,79, .2),
200:Color.fromRGBO(136,14,79, .3),
300:Color.fromRGBO(136,14,79, .4),
400:Color.fromRGBO(136,14,79, .5),
500:Color.fromRGBO(136,14,79, .6),
600:Color.fromRGBO(136,14,79, .7),
700:Color.fromRGBO(136,14,79, .8),
800:Color.fromRGBO(136,14,79, .9),
900:Color.fromRGBO(136,14,79,  1),
};
MaterialColor customColor = MaterialColor(0xFF006064, color);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideOn',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey
      ),
      home: MyHomePage(title: 'RideOn Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static bool _isRecording = false;
  static var currRide;// = new RideObject();
  static double maxSpeed = 0.0;
  var location = new Location();
  static LocationData userLocation;
  Timer _everySecond; //recording frequency timer

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static Set<Polyline> _routes = new Set<Polyline>();
  static int num = 0;

  void addRide(RideObject rideIn)
  {
    num+= 10;
    var latlngList = List<LatLng>();

//    for(int i = 0; i < 100; i++)
//      {
//        latlngList.add(LatLng(40.2444845 + (i)/10000, -111.6474918 + (i+2*num)*(i+num)/1000000));
//      }

    for(int i = 0; i < rideIn.rideRoute.length; i++) {
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

  }

  void _toggleRecording() {
    setState(() {
      if(!_isRecording) {
        _isRecording = true;
        location = new Location();
        currRide = new RideObject();
        currRide.setDate(DateTime.now());
      }
      else if(_isRecording){
        _isRecording = false;
        HistoryRoute.saveRide(currRide);
        addRide(currRide);
        //put it on the database
      }
    });
  }

  void _getLocation(Stream<LocationData> stream) async {
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

  void _getCurrLocation() async {
    //LocationData currentLocation;
    try {
      userLocation = await location.getLocation();
    }
    catch (e){
      userLocation = null;
    }

    //return currentLocation;
  }

  void updateScreen() {
    setState(() {
      if(_isRecording) {
        _getLocation(location.onLocationChanged());
        //.then(() {
          //userLocation = value;
        //});
        currRide.incRideTime();
        currRide.addDistance(userLocation.speed);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //_getCurrLocation();


    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if(_isRecording) updateScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                width: 350,                           //FIXME - Magic number
                height: 500,                          //FIXME - Magic number
              ),
              decoration: BoxDecoration(color: Colors.blue[200]),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.2463985, -111.6541483),
//                      (userLocation == null ? 40.2463985 : userLocation.latitude),
//                      (userLocation == null ? -111.6541483 : userLocation.longitude)

                  zoom: 11.0,
                ),
                polylines: _routes,
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
                      onPressed: () {
                        setState(() {
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


