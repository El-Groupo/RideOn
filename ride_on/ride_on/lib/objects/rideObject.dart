import 'package:flutter/material.dart';

class RideLocation
{
  double latitude;
  double longitude;
}

class RideObject
{
  int rideTimeSec = 0;  //in seconds
  double maxSpeed = 1;
  double avgSpeed = .8;
  var rideRoute = new List<RideLocation>();

  void addPoint(RideLocation newPoint) { rideRoute.add(newPoint); }
  void setMax(double newMax) { maxSpeed = (newMax > maxSpeed) ? newMax : maxSpeed; }
  void setAvg(double newAvg) { avgSpeed = newAvg; }
  void setRideTime(int newRideTime) { rideTimeSec = newRideTime; }
}