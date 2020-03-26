//import 'dart:html';

import 'package:ride_on/objects/vehicleObject.dart';

import 'objects/rideObject.dart';


class Singleton
{
  static final Singleton _singleton = Singleton.internal();
  List<RideObject> myRides = List();
  List<VehicleObject> myToys = List();
  String email;
  String username;
  String userID;

  factory Singleton()
  {
    return _singleton;
  }

  void setEmail(String email) {this.email = email;}
  void setUsername(String username) {this.username = username;}
  void setUserID(String userID) {this.userID = userID;}
  void addRide(RideObject newRide)
  {
    myRides.add(newRide);
  }
  void addToy(VehicleObject newToy)
  {
    myToys.add(newToy);
  }

  List<RideObject> getRides()
  {
    return myRides;
  }
  List<VehicleObject> getToys()
  {
    return myToys;
  }
  String getEmail()
  {
    return email;
  }
  String getUsername()
  {
    return username;
  }
  String getUserID()
  {
    return userID;
  }

  void clearSingleton()
  {
    myRides.clear();
    myToys.clear();
    email = "";
    username = "";
    userID = "";
  }

  Singleton.internal();
}