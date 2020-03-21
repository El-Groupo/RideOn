import 'package:flutter/material.dart';
import 'screens/history.dart';
import 'screens/garage.dart';
import 'screens/account.dart';
import 'screens/settings.dart';
import 'screens/help.dart';

class HamburgerMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("userName"),
            accountEmail: Text("userEmail@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "U",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("Home"),
            onTap: () {
              while(Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text("Garage"),
            onTap: () {
              Navigator.pop(context);  //close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GarageRoute()),
              );
            },
          ),
          ListTile(
            title: Text("History"),
            onTap: () {
              Navigator.pop(context);  //close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryRoute()),
              );
            },
          ),
          ListTile(
            title: Text("Account"),
            onTap: () {
              Navigator.pop(context);  //close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountRoute()),
              );
            },
          ),
          ListTile(
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);  //close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsRoute()),
              );
            },

          ),
          ListTile(
            title: Text("Help"),
            onTap: () {
              Navigator.pop(context);  //close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpRoute()),
              );
            },
          ),
        ]
      ),
    );
  }
}


