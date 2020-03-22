import 'package:flutter/material.dart';
import 'screens/account.dart';
import 'services/authentication.dart';
import 'singleton.dart';

class AccountMenu extends StatelessWidget{

  AccountMenu();
  static var mySingleton = Singleton();
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
    return FlatButton(
      child: new Text('Logout',
          style: new TextStyle(fontSize: 17.0, color: Colors.white)),
      onPressed: signOut,
    );
  }
}


