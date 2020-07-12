import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ride_on/objects/vehicleObject.dart';
import 'package:ride_on/singleton.dart';

//import vehicle class

double mpsTomph(double mpsIn) { return mpsIn * 2.23694; }

class RideLocation
{
  double latitude;
  double longitude;
  RideLocation(latitude, longitude);
}

class RideObject implements Comparable<RideObject>
{
  //core stats
  var mySingleton = Singleton();
  String userId;
  String key;
  double maxSpeed = 0.0;  //in mph
  double rideLength = 0.0;  //in meters
  int rideTimeSec = 0;  //in seconds
  List rideRoute = new List<LatLng>();
  String vehicleName;
  List test = new List<LatLng>();
  List rideRouteDoubles = new List<double>();
  VehicleObject myVehicle;

  //other info
    //vehicle
  DateTime rideDate; //ride date

  void addPoint(LatLng newPoint) {rideRoute.add(newPoint);}
  void setMax(double newMax) {maxSpeed = (mpsTomph(newMax) > maxSpeed) ? mpsTomph(newMax) : maxSpeed;}
  void addDistance(double distanceIn) {rideLength += distanceIn;}
  double getDistance() {return rideLength * .000621371;}
  void incRideTime() {rideTimeSec++;}
  double getAvgSpeed() {return mpsTomph(rideLength / rideTimeSec);}
  void setDate(DateTime dateIn) {rideDate = dateIn;}
  void setName(String name) {vehicleName = name;}
  void setUserID(String userID) {this.userId = userID;}
  void setRideLength(double length) {this.rideLength = length;}
  void setRideTime(int time) {this.rideTimeSec = time;}
  void setRideRouteDoubles (List<double> route)
  {
    this.rideRouteDoubles = route;
    createRoute();
  }
  void setMaxSpeed(double speed) {this.maxSpeed = speed;}
  void setVehicleWithObject(VehicleObject myVehicle) {this.myVehicle = myVehicle;}
  void setVehicleFromDatabase()
  {
    VehicleObject newVehicle = new VehicleObject();
    newVehicle.setNickname(vehicleName);
    newVehicle.setType("other");
    myVehicle = newVehicle;
    for (VehicleObject vehicle in mySingleton.getToys())
    {
        if (vehicleName == vehicle.getNickname()) {
          myVehicle = vehicle;
        }
    }
  }

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
        rideRouteDoubles = snapshot.value["rideRouteDoubles"],
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
      "rideRouteDoubles": myRoute,
      "rideDate": rideDate.toString(),
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
          long = coordinate;
          rideRoute.add(LatLng(lat,long));
        }
        else
        {
          lat = coordinate;
        }
        i++;
      }
  }

  @override
  int compareTo(RideObject anotherRide)
  {
    if (rideDate.isAfter(anotherRide.rideDate)) {
      return 0;
    }
    else return 1;
  }
}