//import 'dart:html';
import 'package:flutter/material.dart';
import 'objects/rideObject.dart';
import 'services/authentication.dart';


class Singleton
{
  static final Singleton _singleton = Singleton.internal();

  List<RideObject> myRides = List();
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

  List<RideObject> getRides()
  {
    return myRides;
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
  VoidCallback getLogoutCallback() { return logoutCallback; }
//*accountMenu Items*
}