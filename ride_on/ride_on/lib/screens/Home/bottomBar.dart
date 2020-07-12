import 'package:flutter/material.dart';

import 'vehicleDisplay.dart';
import 'recordButton.dart';
import 'speedDisplay.dart';

class BottomBar extends StatelessWidget{
  BottomBar();

  @override
  Widget build(BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          VehicleDisplay(),
          RecordButton(),
          SpeedDisplay(),
        ]
    );
  }
}