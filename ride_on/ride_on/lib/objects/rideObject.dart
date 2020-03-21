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
  List rideRoute = new List<LatLng>();
  String vehicleName;
  List test = new List<LatLng>();

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
  void setUserID(String userID) {this.userId = userID;}

  String getUserID() {return userId;}
  double getRideLength() {return rideLength;}
  double getMaxSpeed() {return maxSpeed;}
  int getRideTime() {return rideTimeSec;}
  List getRideRoute() {return rideRoute;}
  String getVehicleName() {return vehicleName;}

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
    List myRoute = new List<double>();
    for (LatLng coordinates in rideRoute)
    {
      myRoute.add(coordinates.latitude);
      myRoute.add(coordinates.longitude);
    }

    return {
      "userId": userId,
      "maxSpeed": maxSpeed,
      "rideLength": rideLength,
      "rideTimeSec": rideTimeSec,
      "rideRoute": myRoute,
      "rideDate": rideDate.toString(),
      "vehiclename": vehicleName,
    };
  }
}