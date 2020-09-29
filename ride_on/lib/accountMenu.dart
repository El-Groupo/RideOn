import 'package:flutter/material.dart';
import 'screens/account.dart';
import 'services/authentication.dart';
import 'singleton.dart';

class AccountMenu extends StatelessWidget{

  AccountMenu();
  static var mySingleton = Singleton();
  var context;



  @override
  Widget build(BuildContext context) {
    this.context = context;
    return IconButton(
      icon: Icon(Icons.account_circle),
      iconSize: 45,
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountRoute()),
        );
      }
    );
  }
}


