import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';

class HelpRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: <Widget>[
                    Text('Ride Date'),
                    Text('Toy Name'),
                    Text('Ride Duration'),
                    Text('Yeet'),
                  ]
              ),
              //garage entries

            ]
        ),
      ),
    );
  }
}