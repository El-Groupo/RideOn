import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ride_on/objects/rideObject.dart';
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(width: 350, height: 500),
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

            )
          ],
        )
      )
    );
  }
}