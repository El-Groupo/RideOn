//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ride_on/objects/vehicleObject.dart';
import 'objects/rideObject.dart';
import 'services/authentication.dart';


class Singleton
{
  factory Singleton() {return _singleton;}
  Singleton.internal();

  static final Singleton _singleton = Singleton.internal();
  final DatabaseReference rideData = FirebaseDatabase.instance.reference().child("ride");

  List<RideObject> myRides = List();
  RideObject currRide;// = new RideObject();
  List<VehicleObject> myToys = List();
  VehicleObject currVehicle = new VehicleObject();
  String email = "";
  String username = "";
  String userID = "";
  VehicleObject currentVehicle;
  bool isRecording = false;
  Location location = new Location();
  LocationData userLocation;
  LatLng currLocation;
  LatLng displayLoc;


  factory Singleton() {return _singleton;}

  void toggleRecording()
  {
    if(!isRecording)
    {
      isRecording = true;
      location = new Location();
      //currRide = new RideObject();
      currRide.setDate(DateTime.now());
      currRide.setVehicleWithObject(currVehicle);

      currRide.setName(currRide.myVehicle.getNickname());
      currRide.setUserID(userID);
    }
    else if(isRecording){
      isRecording = false;
      addRide(currRide);
    }
  }

  void setCurrentVehicle(VehicleObject vehicle) {this.currentVehicle = vehicle;}
  void setEmail(String email) {this.email = email;}
  void setUsername(String username) {this.username = username;}
  void setUserID(String userID) {this.userID = userID;}
  void addRide(RideObject newRide) {myRides.add(newRide);}
  void addToy(VehicleObject newToy) {myToys.add(newToy);}

  List<RideObject> getRides() {return myRides;}
  List<VehicleObject> getToys() {return myToys;}
  String getEmail() {return email;}
  String getUsername() {return username;}
  String getUserID() {return userID;}

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

  void sortRides() {myRides.sort();}
  void sortToys() {myToys.sort();}

  Future<LocationData> getCurrLocation() async
  {
    LocationData currentLocation;

    try {
      currentLocation = await location.getLocation();
    }
    catch (e) {
      currentLocation = null;
    }

    return currentLocation;
  }

  void getLocation(Stream<LocationData> stream) async
  {
    try {
      await for(LocationData value in stream)
      {
        currRide.setMax(value.speed);
        currRide.addPoint(
            LatLng(value.latitude, value.longitude));
        userLocation = value;
        //location.getLocation();
      }
    }
    catch (e){
//      userLocation = null;
    }

    //return currentLocation;
  }

}