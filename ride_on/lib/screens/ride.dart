import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ride_on/objects/rideObject.dart';
import '../accountMenu.dart';
import '../singleton.dart';

class RideRoute extends StatelessWidget
{
  var mySingleton = Singleton();
  RideObject myRide;
  RideRoute(RideObject myRide)
  {
    this.myRide = myRide;
    startingLocation = myRide.rideRoute.first;
    endingLocation = myRide.rideRoute.last;
    setMapPins();
    setPolyLines();
  }

  LatLng startingLocation;
  LatLng endingLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  //PolylinePoints polylinePoints = PolylinePoints();

  //Completer<GoogleMapController> mapController = Completer();
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller)
  {
    mapController = controller;
    //setMapPins();
    //setPolyLines();
  }

  void setMapPins()
  {
    //setState(() {
      // source pin
      markers.add(Marker(
          markerId: MarkerId('Start'),
          position: startingLocation,
          //icon: Icons.location_on,
      ));
      // destination pin
      markers.add(Marker(
          markerId: MarkerId('End'),
          position: endingLocation,
          //icon: Icons.location_on,
      ));
    //});
  }

  void setPolyLines()
  {
    Polyline polyline = Polyline(
      polylineId: PolylineId(""),
      color: Colors.blue,
      points: myRide.rideRoute
    );
    polylines.add(polyline);
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text(myRide.vehicleName),
        actions: <Widget>[
          AccountMenu(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                  width: MediaQuery.of(context).size.width*.95,
                  height: MediaQuery.of(context).size.width*.5),
              decoration: BoxDecoration(color: Colors.blue[200]),
                 child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: startingLocation,
                      zoom: 17.0,
                    ),
                    polylines: polylines,
                    markers: markers,
                  )

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Top Speed'),
                    Text(myRide.maxSpeed.toString()),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Distance'),
                    Text(myRide.rideLength.toString()),
                    Text('Duration'),
                    Text(getHours()),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Date'),
                    Text(getDate()),
                  ],
                )
              ],
            )
          ],
        )
      )
    );
  }

  String getHours() {
    String rideTime = "0";
    double totalMinutes = myRide.rideTimeSec / 60;
    double hours = totalMinutes / 60;
    double minutes = totalMinutes % 60;
    int hrs = hours.truncate();
    int min = totalMinutes.truncate() - (hrs * 60);
    double seconds = (totalMinutes - min.toDouble()) * 60;
    int sec = seconds.truncate();
    rideTime = hrs.toString() + ":" + min.toString() + "." + sec.toString().substring(0,1);
    return rideTime;
  }

  String getDate()
  {
    int monthInt = myRide.rideDate.month;
    String month;
    int day = myRide.rideDate.day;
    int year = myRide.rideDate.year;

    switch (monthInt)
    {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }

    return month + " " + day.toString() + ", " + year.toString();
  }
}

/*
5910 timesecint
total min = 98.5
hours = 1.6416
hrs = 1
min = 98-60 = 38
sec = (totalmin - min) * 60


 */