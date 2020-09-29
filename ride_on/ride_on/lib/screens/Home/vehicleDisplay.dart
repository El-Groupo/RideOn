import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:ride_on/objects/vehicleObject.dart';
import 'package:ride_on/objects/rideObject.dart';
import 'package:ride_on/singleton.dart';

class VehicleDisplay extends StatefulWidget {
  VehicleDisplay();

  @override
  State<StatefulWidget> createState() => _VehicleDisplayState();
}

class _VehicleDisplayState extends State<StatefulWidget>{
  var mySingleton = Singleton();

  var vehicleRef = FirebaseDatabase.instance.reference().child("vehicle");

  DateTime parseDate(String date)
  {
    String year = date.substring(0,4);
    String month = date.substring(5,7);
    String day = date.substring(8,10);
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
  }

  String displayCurrentVehicle()
  {
    String nickname = "vehicle not selected";
    for (VehicleObject vehicleObject in mySingleton.getToys()){
      if (vehicleObject.isCurrentVehicle) {
        mySingleton.currRide.setVehicleWithObject(vehicleObject);
        nickname = vehicleObject.getNickname();
        mySingleton.currVehicle = vehicleObject;
      }
    }
    return nickname;
  }

  void setCurrentVehicle(VehicleObject vehicle){
    for (VehicleObject aVehicle in mySingleton.getToys())
    {
      if (aVehicle.getNickname() == vehicle.getNickname()) {
        mySingleton.currRide.setVehicleWithObject(vehicle);
        aVehicle.setIsCurrentVehicle(true);
        mySingleton.currVehicle = aVehicle;
      }
      else {
        aVehicle.setIsCurrentVehicle(false);
      }
      vehicleRef.child(aVehicle.key).set(aVehicle.toJson());
    }
  }

  //Stuff for adding a vehicle, taken from the garage
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  DateTime newPurchaseDate;
  String newToyNickname = "";
  VehicleType newToyType;

  showSelectVehicle(BuildContext context) async
  {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select your vehicle"),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: mySingleton.getToys().length,
                    itemBuilder: getListItemTile,
                  ),
                  SelectableText(
                    'Add vehicle',
                    onTap: () {
                      showAddVehicleDialog(context);
                    },
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
  }

  Widget getListItemTile(BuildContext context, int index)
  {
    return GestureDetector(
      onTap: () {
        setState(() {
          mySingleton.currRide.setVehicleWithObject(mySingleton.getToys()[index]);
          mySingleton.currRide.setName(mySingleton.getToys()[index].getNickname());
          setCurrentVehicle(mySingleton.getToys()[index]);
        });
        Navigator.pop(context);
      },

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Colors.white,
        child: ListTile(
          title: Text(mySingleton.getToys()[index].getNickname()),
        ),
      ),
    );
  }

  showAddVehicleDialog(BuildContext context) async
  {
    nameController.clear();
    dateController.clear();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: new Text("Add New Vehicle"),
            content: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "Vehicle Name",
                  ),
                ),
                TextFormField(
                  controller: dateController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: "Purchase date yyyy-mm-dd",
                  ),
                ),
                DropdownButton(
                  hint: Text('Please select vehicle type'),
                  value: newToyType,
                  onChanged: (newValue) {
                    setState(() {
                      newToyType = newValue;
                    });
                  },
                  items: VehicleType.values.map((type) {
                    return DropdownMenuItem(
                      child: new Text(printVehicleType(type)),
                      value: type,
                    );
                  }).toList(),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewVehicle(nameController.text.toString(), dateController.text.toString());
                    Navigator.pop(context);
                  }),
            ]
        );
      });
  }

  String printVehicleType(VehicleType type) {
    String vehicleType = "";
    switch(type)
    {
      case VehicleType.motorcycle:
        vehicleType += "Motorcycle";
        break;
      case VehicleType.fourWheeler:
        vehicleType += "4 Wheeler";
        break;
      case VehicleType.utv:
        vehicleType += "UTV";
        break;
      case VehicleType.other:
        vehicleType += "Other";
        break;
    }
    return vehicleType;
  }

  void addNewVehicle(String name, String date)
  {
    VehicleObject newVehicle = new VehicleObject();
    newVehicle.setNickname(name);
    newVehicle.setPurchaseDate(parseDate(date));
    newVehicle.setEnumType(newToyType);
    newVehicle.setTopSpeed(0.0);
    newVehicle.setTotalHours(0.0);
    newVehicle.setUserId(mySingleton.userID);
    vehicleRef.push().set(newVehicle.toJson());
    newVehicle.getCreatedKey();
    setCurrentVehicle(newVehicle);
    mySingleton.currVehicle = newVehicle;
    mySingleton.addToy(newVehicle);
    mySingleton.sortToys();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SelectableText(
          displayCurrentVehicle(),
          onTap: () {
            showSelectVehicle(context);
          },
        ),
        Text(
          'Current Speed\n' +
              ((mySingleton.userLocation != null && mySingleton.isRecording) ?
              mpsTomph(mySingleton.userLocation.speed).toStringAsFixed(2) + ' mph' : ''
          ),
        ),
      ]
    );
  }
}