import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_on/objects/rideObject.dart';
import 'package:ride_on/objects/vehicleObject.dart';
import 'ride.dart';
import '../accountMenu.dart';
import '../singleton.dart';

// ignore: must_be_immutable
class VehicleRoute extends StatelessWidget
{
  VehicleRoute(VehicleObject myToy)
  {
    this.myToy = myToy;
    setIcon();
    getRides();
  }

  var mySingleton = Singleton();

  String icon;
  VehicleObject myToy;
  List<RideObject> rideHistory = List();

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(myToy.toyNickname),
          actions: <Widget>[
            AccountMenu(),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(icon),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                        children: <Widget>[
                          Text('Top Speed'),
                          Text(myToy.allTimeTopSpeed.toString() + " mph"),

                        ]
                    ),
                    Column(
                      children: <Widget>[
                        Text('Total Hours'),
                        Text(getHours()),
                        Text('Total Miles'),
                        Text(myToy.totalVehicleMiles.toString()),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Purchase Date'),
                        Text(getDate()),
                      ],
                    )
                  ],
                ),
                showRideList(),
              ],
            )

        )
    );
  }

  void setIcon() {
    VehicleType toyType = myToy.toyType;
    if (toyType == VehicleType.motorcycle) {
      icon = "lib/media/images/dirtbike.PNG";
    }
    else if (toyType == VehicleType.fourWheeler) {
      icon = "lib/media/images/4wheeler.PNG";
    }
    else if (toyType == VehicleType.utv) {
      icon = "lib/media/images/utv.PNG";
    }
    else {
      icon = "lib/media/images/dirtbike.PNG";
    }
  }

  String getHours()
  {
    String rideTime = "0";
    double totalMinutes = myToy.totalVehicleHours / 60;
    double hours = totalMinutes / 60;
    double minutes = totalMinutes % 60;
    if (hours < 1) {
      try {
        rideTime = minutes.toString().substring(0, 4) + " minutes";
      }
      catch (Exception) {
        rideTime = "0 hours";
      }
    }
    else {
      int hrs = hours.truncate();
      rideTime = hrs.toString() + " hours";
    }

    return rideTime;
  }

  String getDate()
  {
    int monthInt = myToy.purchaseDate.month;
    String month;
    int day = myToy.purchaseDate.day;
    int year = myToy.purchaseDate.year;

    switch (monthInt)
    {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }

    return month + " " + day.toString() + ", " + year.toString();
  }

  void getRides()
  {
    for (RideObject rideObject in mySingleton.myRides) {
      if (rideObject.myVehicle == myToy) {
        rideHistory.add(rideObject);
      }
    }
  }

  Widget showRideList()
  {

    if (rideHistory.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rideHistory.length,
          itemBuilder: (BuildContext context, int index) {
            String rideId = rideHistory[index].key;
            DateTime rideDate = rideHistory[index].rideDate;
            String vehicleName = rideHistory[index].vehicleName;
            String userId = rideHistory[index].userId;
            int rideDuration = rideHistory[index].rideTimeSec;
            double maxSpeed = rideHistory[index].maxSpeed;
            VehicleType toyType = rideHistory[index].myVehicle.toyType;
            return Dismissible(
              key: Key(rideId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                //deleteTodo(todoId, index);
              },
              child: ListTile(

                leading: Image.asset(icon),
                title: Text(vehicleName),
                subtitle: Text(
                    maxSpeed.toStringAsFixed(2) + " mph | " + getRideHours(rideHistory[index])),
                trailing: Icon(Icons.more_vert),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RideRoute(rideHistory[index])),
                  );
                },
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

  String getRideHours(RideObject myRide) {
    String rideTime = "0";
    double totalMinutes = myRide.rideTimeSec / 60;
    double hours = totalMinutes / 60;
    double minutes = totalMinutes % 60;
    int hrs = hours.truncate();
    int min = totalMinutes.truncate() - (hrs * 60);
    double seconds = (totalMinutes - min.toDouble()) * 60;
    int sec = seconds.truncate();
    rideTime = "Duration: " + hrs.toString() + ":" + min.toString() + "." + sec.toString().substring(0,1);
    return rideTime;
  }

}