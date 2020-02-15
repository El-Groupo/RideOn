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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Contact Email: ttbh.group@gmail.com'),
            ]
        ),
      ),
    );
  }
}