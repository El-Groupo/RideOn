import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum VehicleType {motorcycle, utv, fourWheeler, other}


class VehicleObject
{
  VehicleObject();

  String userId;
  String key;
  DateTime purchaseDate;
  double allTimeTopSpeed = 0.0;
  double totalVehicleHours = 0.0;
  String toyNickname = "";
  VehicleType toyType;
  bool isCurrentVehicle = true;
  double totalVehicleMiles = 0.0;

  //Setters needed to fill after grabbing from database
  void setTotalMiles(double miles) {this.totalVehicleMiles = miles;}
  void setIsCurrentVehicle(bool isIt) {this.isCurrentVehicle = isIt;}
  void setUserId(String userId) {this.userId = userId;}
  void setPurchaseDate(DateTime date) {this.purchaseDate = date;}
  void setTopSpeed(double speed) {this.allTimeTopSpeed = speed;}
  void setTotalHours(double hours) {this.totalVehicleHours = hours;}
  void setNickname(String name) {this.toyNickname = name;}
  void setEnumType(VehicleType type) {this.toyType = type;}
  void setType(String type)
  {
    if(type == VehicleType.motorcycle.toString()) {
      toyType = VehicleType.motorcycle;
    }
    else if(type == VehicleType.utv.toString()) {
      toyType = VehicleType.utv;
    }
    else if(type == VehicleType.fourWheeler.toString()) {
      toyType = VehicleType.fourWheeler;
    }
    else {
      toyType = VehicleType.other;
    }
  }

  //Getters
  double getMiles() {return totalVehicleMiles;}
  String getUserId() {return userId;}
  DateTime getPurchaseDate() {return purchaseDate;}
  double getTopSpeed() {return allTimeTopSpeed;}
  double getTotalHours() {return totalVehicleHours;}
  String getNickname() {return toyNickname;}
  VehicleType getType() {return toyType;}
  bool getIsCurrentVehicle() {return isCurrentVehicle;}

  //Adjust top speed after ride
  void adjustTopSpeed(double speed)
  {
    if (speed > allTimeTopSpeed)
      {
        allTimeTopSpeed = speed;
      }
    //todo: make this edit in the database
  }
  //adjust miles after ride
  void adjustMiles(double miles)
  {
    totalVehicleMiles += miles;
  }

  void adjustHours(int seconds)
  {
    totalVehicleHours += seconds;
  }

  //get firebase key after adding a new vehicle
  void getCreatedKey()
  {
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("vehicle");
    reference.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      for (var key in KEYS)
        {
          String nickname = DATA[key]['toyNickname'];
          if (nickname == toyNickname)
            {
              this.key = key;
            }
        }
    }
    );
  }

  //Snapshot for retrieving data from database
  VehicleObject.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      purchaseDate = snapshot.value["purchaseDate"],
      allTimeTopSpeed = snapshot.value["allTimeTopSpeed"],
      totalVehicleHours = snapshot.value["totalVehicleHours"],
      toyNickname = snapshot.value["toyNickname"],
      toyType = snapshot.value["toyType"],
      isCurrentVehicle = snapshot.value["isCurrentVehicle"],
      totalVehicleMiles = snapshot.value["totalVehicleMiles"];

  toJson()
  {
    return {
      "userId" : userId,
      "purchaseDate" : purchaseDate.toString(),
      "allTimeTopSpeed" : allTimeTopSpeed,
      "totalVehicleHours" : totalVehicleHours,
      "toyNickname" : toyNickname,
      "toyType" :toyType.toString(),
      "isCurrentVehicle" : isCurrentVehicle.toString(),
      "totalVehicleMiles" : totalVehicleMiles,
    };
  }

  toString()
  {
    String vehicleDetails = "";
    switch(toyType)
    {
      case VehicleType.motorcycle:
        vehicleDetails += "Motorcycle";
        break;
      case VehicleType.fourWheeler:
        vehicleDetails += "4Wheeler";
        break;
      case VehicleType.utv:
        vehicleDetails += "UTV";
        break;
      case VehicleType.other:
        vehicleDetails += "Something dope";
        break;
    }
    vehicleDetails += ' purchased on ' +
    purchaseDate.month.toString() + '/' +
        purchaseDate.day.toString() + '/' +
        purchaseDate.year.toString();
    return vehicleDetails;
  }


}