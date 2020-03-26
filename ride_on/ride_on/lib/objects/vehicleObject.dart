import 'package:firebase_database/firebase_database.dart';

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

  //Setters needed to fill after grabbing from database
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
  String getUserId() {return userId;}
  DateTime getPurchaseDate() {return purchaseDate;}
  double getTopSpeed() {return allTimeTopSpeed;}
  double getTotalHours() {return totalVehicleHours;}
  String getNickname() {return toyNickname;}
  VehicleType getType() {return toyType;}

  //Adjust top speed after ride
  void adjustTopSpeed(double speed)
  {
    if (speed > allTimeTopSpeed)
      {
        allTimeTopSpeed = speed;
      }
    //todo: make this edit in the database
  }

  //Snapshot for retrieving data from database
  VehicleObject.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      purchaseDate = snapshot.value["purchaseDate"],
      allTimeTopSpeed = snapshot.value["allTimeTopSpeed"],
      totalVehicleHours = snapshot.value["totalVehicleHours"],
      toyNickname = snapshot.value["toyNickname"],
      toyType = snapshot.value["toyType"];

  toJson()
  {
    return {
      "userId" : userId,
      "purchaseDate" : purchaseDate.toString(),
      "allTimeTopSpeed" : allTimeTopSpeed,
      "totalVehicleHours" : totalVehicleHours,
      "toyNickname" : toyNickname,
      "toyType" :toyType.toString(),
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