import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_on/objects/vehicleObject.dart';
import '../singleton.dart';

// ignore: must_be_immutable
class VehicleRoute extends StatelessWidget
{
  VehicleRoute(VehicleObject myToy)
  {
    this.myToy = myToy;
    setIcon();
  }

  var mySingleton = Singleton();

  String icon;
  VehicleObject myToy;

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(myToy.toyNickname),
        ),
        body: Center(
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
                )
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
}