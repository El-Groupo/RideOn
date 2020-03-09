import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';
import '../login_pages/login_signup_page.dart';
import '../login_pages/root_page.dart';
import 'home.dart';
import '../services/authentication.dart';

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
              Text('Logout'),
              /*FlatButton(
                padding: EdgeInsets.all(0),
                //onPressed: new RootPage(auth: new Auth());
                onPressed: ()
                {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => LoginSignupPage()));
                }),*/
            ],
          )
      ),
    );
  }
}