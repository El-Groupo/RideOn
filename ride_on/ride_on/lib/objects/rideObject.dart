import 'package:flutter/material.dart';

double mpsTomph(double mpsIn) { return mpsIn * 2.23694; }

class RideLocation
{
  double latitude;
  double longitude;
  RideLocation(latitude, longitude);
}

class RideObject
{
  double maxSpeed = -.5;  //in mph
  int rideTimeSec = 0;  //in seconds
  double rideLength = -.1;  //in meters
  var rideRoute = new List<RideLocation>();

  void addPoint(RideLocation newPoint) { rideRoute.add(newPoint); }
  void setMax(double newMax) { maxSpeed = (mpsTomph(newMax) > maxSpeed) ? mpsTomph(newMax) : maxSpeed; }
  void addDistance(double distanceIn) { rideLength += distanceIn; }
  void incRideTime() { rideTimeSec++; }
  double getAvgSpeed() { return mpsTomph(rideLength / rideTimeSec);}
}