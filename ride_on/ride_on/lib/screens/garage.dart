import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Text('Toy Name'),
                Text('Make'),
                Text('Model'),
                Text('Last Ride'),
              ]
            ),
            //garage entries

          ]
        ),
      ),
    );
  }
}