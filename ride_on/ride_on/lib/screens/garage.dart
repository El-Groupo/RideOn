import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';


TextStyle tableHeader()
{
  return TextStyle(
    fontSize: 15,
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

class GarageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage'),
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
                      Text('\tVehicle Name',
                        style: tableHeader(),
                      ),
                      Text('\tMake',
                        style: tableHeader(),
                      ),
                      Text('\tModel',
                        style: tableHeader(),
                      ),
                      Text('\tYear',
                        style: tableHeader(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Text('\tBig Red',
                        style: tableData(),
                      ),
                      Text('\tHonda',
                        style: tableData(),
                      ),
                      Text('\tcx500',
                        style: tableData(),
                      ),
                      Text('\tswag',
                        style: tableData(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Text('\tFlinstone Car',
                        style: tableData(),
                      ),
                      Text('\tSedimentary',
                        style: tableData(),
                      ),
                      Text('\tModel 1',
                        style: tableData(),
                      ),
                      Text('\tswog',
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