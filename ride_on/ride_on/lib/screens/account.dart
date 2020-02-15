import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';

class AccountRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Username: IBeDaUser'),
            Text('email: userEmail@gmail.com'),
            Text('Quest: To seek the holy grail'),
            Text('Favorite Color: Green'),
          ]
        ),
      ),
    );
  }
}