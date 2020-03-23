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
<<<<<<< Updated upstream
=======
  List test = new List<LatLng>();
  List rideRouteDoubles = new List<double>();
>>>>>>> Stashed changes

  //other info
    //vehicle
  DateTime rideDate; //ride date

  void addPoint(LatLng newPoint) { rideRoute.add(newPoint); }
  void setMax(double newMax) { maxSpeed = (mpsTomph(newMax) > maxSpeed) ? mpsTomph(newMax) : maxSpeed; }
  void addDistance(double distanceIn) { rideLength += distanceIn; }
  double getDistance() { return rideLength * .000621371; }
  void incRideTime() { rideTimeSec++; }
  double getAvgSpeed() { return mpsTomph(rideLength / rideTimeSec);}
  void setDate(DateTime dateIn) {
    rideDate = dateIn; }
  void setName(String name) { vehicleName = name; }
<<<<<<< Updated upstream
=======
  void setUserID(String userID) {
    this.userId = userID;}
  void setRideLength(double length) {this.rideLength = length;}
  void setRideTime(int time) {this.rideTimeSec = time;}
  void setRideRouteDoubles (List<double> route) {this.rideRouteDoubles = route;}
  void setMaxSpeed(double speed) {this.maxSpeed = speed;}

  String getUserID() {return userId;}
  double getRideLength() {return rideLength;}
  double getMaxSpeed() {return maxSpeed;}
  int getRideTime() {return rideTimeSec;}
  List getRideRoute() {return rideRoute;}
  String getVehicleName() {return vehicleName;}
>>>>>>> Stashed changes


  RideObject();
  //RideObject(this.maxSpeed, this.userId, this.rideLength, this.rideTimeSec, this.rideRoute, this.rideDate, this.vehicleName);

  RideObject.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        maxSpeed = snapshot.value["maxSpeed"],
        rideLength = snapshot.value["rideLength"],
        rideTimeSec = snapshot.value["rideTimeSec"],
        rideRouteDoubles = snapshot.value["rideRouteDoubles"],
        rideDate = snapshot.value["rideDate"],
        vehicleName = snapshot.value["vehicleName"];

  toJson() {
    return {
      "userId": userId,
      "maxSpeed": maxSpeed,
      "rideLength": rideLength,
      "rideTimeSec": rideTimeSec,
<<<<<<< Updated upstream
      "rideRoute": rideRoute,
      "rideDate": rideDate,
=======
      "rideRouteDoubles": myRoute,
      "rideDate": rideDate.toString(),
>>>>>>> Stashed changes
      "vehiclename": vehicleName,
    };
  }

  void createRoute()
  {
    double lat = 0;
    double long = 0;
    int i = 0;
    for (double coordinate in rideRouteDoubles)
      {
        if (i%2 == 1)
        {
          lat = coordinate;
        }
        else
        {
          long = coordinate;
          rideRoute.add(LatLng(lat,long));
        }
      }
  }
}