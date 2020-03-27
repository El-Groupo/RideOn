import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ride_on/objects/vehicleObject.dart';
import 'package:ride_on/singleton.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../objects/rideObject.dart';
import '../services/authentication.dart';



TextStyle tableHeader()
{
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic,
  );
}

TextStyle tableData()
{
  return TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
  );
}

class GarageRoute extends StatefulWidget
{
  GarageRoute({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _GarageRouteState();
}

class _GarageRouteState extends State<GarageRoute>
{
  _GarageRouteState({this.user});
  DateTime newPurchaseDate;
  double newAllTimeTopSpeed = 0.0;
  double newTotalVehicleHours = 0.0;
  String newToyNickname = "";
  VehicleType newToyType;
  final nameController = TextEditingController();
  final dateController = TextEditingController();

  var mySingleton = Singleton();
  List<VehicleObject> toyList = List();

  final FirebaseUser user;
  final DatabaseReference vehicleRef = FirebaseDatabase.instance.reference().child("vehicle");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState()
  {
    super.initState();
    toyList = mySingleton.getToys();

  }

  @override
  void dispose()
  {
    //cleans text controller for adding vehicle
    //nameController.dispose();
    //dateController.dispose();
    super.dispose();
  }

  Widget showRideList() {

    if (toyList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: toyList.length,
          itemBuilder: (BuildContext context, int index) {
            String toyId = toyList[index].key;
            DateTime purchaseDate = toyList[index].purchaseDate;
            String nickName = toyList[index].toyNickname;
            String userId = toyList[index].userId;
            VehicleType toyType = toyList[index].toyType;
            double totalHours = toyList[index].totalVehicleHours;
            double maxSpeed = toyList[index].allTimeTopSpeed;
            return Dismissible(
              key: Key(toyId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                //deleteTodo(todoId, index);
              },
              child: ListTile(

                leading: FlutterLogo(size: 56.0),
                title: Text(nickName),
                subtitle: Text(
                    toyList[index].toString()),
                trailing: Icon(Icons.more_vert),

              ),
            );
          });
    } else {
      return Center(
          child: Text(
            "Welcome. Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Garage'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: signOut)
        ],
      ),
      drawer: HamburgerMenu(),
      body: showRideList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddVehicleDialog(context);
        },
        child: Icon(Icons.add),
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
    mySingleton.addToy(newVehicle);
    vehicleRef.push().set(newVehicle.toJson());
  }



  DateTime parseDate(String date)
  {
    String year = date.substring(0,4);
    String month = date.substring(5,7);
    String day = date.substring(8,10);
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

}