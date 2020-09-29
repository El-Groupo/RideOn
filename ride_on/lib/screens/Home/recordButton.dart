import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:ride_on/singleton.dart';

class RecordButton extends StatefulWidget
{
  RecordButton();

  @override
  State<StatefulWidget> createState() => new _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>{
  var mySingleton = Singleton();

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: ()
          {
            setState(()
            {
              mySingleton.toggleRecording();
            });
          },
          tooltip: 'Begin Recording',
          //child: Icon(Icons.),
        ),
        Text(
          mySingleton.isRecording ? 'Recording\n'+ mySingleton.currRide.rideTimeSec.toString() + 's' : 'Record',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}