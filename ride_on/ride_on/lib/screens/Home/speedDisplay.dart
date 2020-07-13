import 'package:flutter/material.dart';

import 'package:ride_on/singleton.dart';

class SpeedDisplay extends StatefulWidget{
  SpeedDisplay();

  State<StatefulWidget> createState() => _SpeedDisplay();
}

class _SpeedDisplay extends State<StatefulWidget>{
  var mySingleton = Singleton();

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Top Speed\n' +
              (mySingleton.isRecording ? mySingleton.currRide.maxSpeed.toStringAsFixed(1) : '--') +
              ' mph',
          textAlign: TextAlign.center,
        ),

        Text(
          'Avg Speed\n' +
              (mySingleton.isRecording ? mySingleton.currRide.getAvgSpeed().toStringAsFixed(1) : '--') +
              ' mph',
          textAlign: TextAlign.center,
        ),
      ]
    );
  }
}