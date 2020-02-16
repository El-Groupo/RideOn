import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';


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