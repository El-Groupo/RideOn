import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

//import vehicle class

double mpsTomph(double mpsIn) { return mpsIn * 2.23694; }

class RideLocation
{
  double latitude;
  double longitude;
  RideLocation(latitude, longitude);
}

class RideObject
{
  //core stats
  String userId;
  String key;
  double maxSpeed = 0.0;  //in mph
  double rideLength = 0.0;  //in meters
  int rideTimeSec = 0;  //in seconds
  var rideRoute = new List<LatLng>();
  String vehicleName;

  //other info
    //vehicle
  DateTime rideDate; //ride date

  void addPoint(LatLng newPoint) { rideRoute.add(newPoint); }
  void setMax(double newMax) { maxSpeed = (mpsTomph(newMax) > maxSpeed) ? mpsTomph(newMax) : maxSpeed; }
  void addDistance(double distanceIn) { rideLength += distanceIn; }
  double getDistance() { return rideLength * .000621371; }
  void incRideTime() { rideTimeSec++; }
  double getAvgSpeed() { return mpsTomph(rideLength / rideTimeSec);}
  void setDate(DateTime dateIn) { rideDate = dateIn; }
  void setName(String name) { vehicleName = name; }

  RideObject();
  //RideObject(this.maxSpeed, this.userId, this.rideLength, this.rideTimeSec, this.rideRoute, this.rideDate, this.vehicleName);

  RideObject.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        maxSpeed = snapshot.value["maxSpeed"],
        rideLength = snapshot.value["rideLength"],
        rideTimeSec = snapshot.value["rideTimeSec"],
        rideRoute = snapshot.value["rideRoute"],
        rideDate = snapshot.value["rideDate"],
        vehicleName = snapshot.value["vehicleName"];

  toJson() {
    return {
      "userId": userId,
      "maxSpeed": maxSpeed,
      "rideLength": rideLength,
      "rideTimeSec": rideTimeSec,
      "rideRoute": rideRoute,
      "rideDate": rideDate,
      "vehiclename": vehicleName,
    };
  }
}