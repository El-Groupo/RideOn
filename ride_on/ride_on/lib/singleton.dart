//import 'dart:html';
import 'package:flutter/material.dart';
import 'objects/rideObject.dart';
import 'services/authentication.dart';

import 'package:ride_on/objects/vehicleObject.dart';



class Singleton
{
  static final Singleton _singleton = Singleton.internal();
  List<RideObject> myRides = List();
  List<VehicleObject> myToys = List();
  String email = "";
  String username = "";
  String userID = "";
  VehicleObject currentVehicle;

  factory Singleton()
  {
    return _singleton;
  }

  void setCurrentVehicle(VehicleObject vehicle) {this.currentVehicle = vehicle;}
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

  Singleton.internal();

  //accountMenu (logout) items
  BaseAuth auth;
  VoidCallback logoutCallback;

  void setAuth(BaseAuth auth) { this.auth = auth; }
  void setLogoutCallback(VoidCallback logoutCallback) { this.logoutCallback = logoutCallback; }

  BaseAuth getAuth() { return auth; }
  VoidCallback getLogoutCallback()
  { 
     clearSingleton();
      return logoutCallback;
  }
//*accountMenu Items*
  VehicleObject getCurrentVehicle() {return currentVehicle;}

  void clearSingleton()
  {
    myRides.clear();
    myToys.clear();
    email = "";
    username = "";
    userID = "";
  }

}