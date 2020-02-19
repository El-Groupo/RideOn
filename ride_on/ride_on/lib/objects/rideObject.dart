import 'package:flutter/material.dart';
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
  double maxSpeed = 0.0;  //in mph
  double rideLength = 0.0;  //in meters
  int rideTimeSec = 0;  //in seconds
  var rideRoute = new List<RideLocation>();

  //other info
    //vehicle
  DateTime rideDate; //ride date

  void addPoint(RideLocation newPoint) { rideRoute.add(newPoint); }
  void setMax(double newMax) { maxSpeed = (mpsTomph(newMax) > maxSpeed) ? mpsTomph(newMax) : maxSpeed; }
  void addDistance(double distanceIn) { rideLength += distanceIn; }
  void incRideTime() { rideTimeSec++; }
  double getAvgSpeed() { return mpsTomph(rideLength / rideTimeSec);}
  void setDate(DateTime dateIn) { rideDate = dateIn; }
}