import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';
import '../objects/rideObject.dart';


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

class HistoryRoute extends StatelessWidget {
  static List<RideObject> rideHistory = List();
  static var newRideHistory = List<RideObject>();

  static void saveRide(RideObject newRide)
  {
    newRideHistory.add(newRide);
  }

//  Widget generateHistoryTableRow(RideObject rideIn)
//  {
//    return TableRow(
//      children: <Widget>[
//        Text(rideIn.rideDate.toIso8601String(),
//          style: tableData(),
//        ),
//        Text('\tVehicle Name',
//          style: tableData(),
//        ),
//        Text(rideIn.rideTimeSec.toString(),
//          style: tableData(),
//        ),
//        Text('\tyote',
//          style: tableData(),
//        ),
//      ],
//    ),
//
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
          children: <Widget>[
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(),
                verticalInside: BorderSide(),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: FlexColumnWidth(100),
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
//                    border: Border(
//                      bottom: BorderSide(),
//                      right: BorderSide(),
//                    ),
                  ),
                  children: <Widget>[
                    Text('\tRide Date',
                        style: tableHeader(),
                    ),
                    Text('\tVehicle Name',
                      style: tableHeader(),
                    ),
                    Text('\tRide Duration',
                      style: tableHeader(),
                    ),
                    Text('\tYeet',
                      style: tableHeader(),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Text('\tLike Yesterday',
                        style: tableData(),
                    ),
                    Text('\tBig Red',
                      style: tableData(),
                    ),
                    Text('\t45 seconds',
                      style: tableData(),
                    ),
                    Text('\tyeet',
                      style: tableData(),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Text('\t27 BC',
                      style: tableData(),
                    ),
                    Text('\tFlinstone Car',
                      style: tableData(),
                    ),
                    Text('\t7 days',
                      style: tableData(),
                    ),
                    Text('\tyaga',
                      style: tableData(),
                    ),
//                    generateHistoryTableRow(rideHistory[0]),
                  ],
                ),
                if(newRideHistory.length >= 1) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[0].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[0].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[0].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 2) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[1].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[1].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[1].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 3) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[2].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[2].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[2].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 4) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[3].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[3].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[3].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 5) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[4].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[4].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[4].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 6) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[5].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[5].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[5].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 7) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[6].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[6].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[6].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 8) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[7].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[7].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[7].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 9) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[8].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[8].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[8].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
                if(newRideHistory.length >= 10) TableRow(
                  children: <Widget>[
                    Text('\t' + newRideHistory[9].rideDate.toUtc().toString().substring(0, 10),
                      style: tableData(),
                    ),
                    Text('\tVehicle Name',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[9].rideTimeSec.toString() + 's',
                      style: tableData(),
                    ),
                    Text('\t' + newRideHistory[9].getDistance().toStringAsFixed(4) + 'mi',
                      style: tableData(),
                    ),
                  ],
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}