import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Text('App Color: Based on my rides'),
            Text('Some other setting'),
            Text('Yeet'),
          ]
        ),
      ),
    );
  }
}