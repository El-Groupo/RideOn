import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget
{
  RecordButton();

  @override
  Widget build(BuildContect context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: ()
          {
            setState(()
            {
              _toggleRecording();
            });
          },
          tooltip: 'Begin Recording',
          //child: Icon(Icons.),
        ),
        Text(
          _isRecording ? 'Recording\n'+ currRide.rideTimeSec.toString() + 's' : 'Record',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}