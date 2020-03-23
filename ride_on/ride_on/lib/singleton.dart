//import 'dart:html';

import 'objects/rideObject.dart';


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

  void clearSingleton()
  {
    myRides.clear();
    email = "";
    username = "";
    userID = "";
  }

  Singleton.internal();
}