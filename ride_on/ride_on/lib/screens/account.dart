import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';
import 'package:ride_on/singleton.dart';

class AccountRoute extends StatelessWidget {

  var mySingleton = Singleton();
  var context;

  signOut() async {

    while(Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    try {
      await mySingleton.auth.signOut();
      mySingleton.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      drawer: HamburgerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Username: ' + mySingleton.userID),
            Text('e-mail: ' + mySingleton.email),
            Text('Quest: To seek the holy grail'),
            Text('Favorite Color: Green'),
            FlatButton(
              child: Text("Sign Out"),
              onPressed: signOut,
            ),
          ]
        ),
      ),
    );
  }
}