import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../hamburgerMenu.dart';
import '../login_pages/login_signup_page.dart';
import '../login_pages/root_page.dart';
import 'home.dart';
import '../services/authentication.dart';

class SettingsRoute extends StatefulWidget {

  SettingsRoute(
      {Key key, this.title, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final String title;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _SettingsRouteState();

}

class _SettingsRouteState extends State<SettingsRoute>
{
  _SettingsRouteState({this.user});
  final FirebaseUser user;


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
              ListTile(
                title: Text("App Color: based on my rides"),
                onTap:()
                {

                },
              ),
              ListTile(
                title: Text('App Color: Based on my rides'),
              ),
              ListTile(
                title: Text('Some other setting'),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: ()
                {
                  signOut();
                },
              ),
            ],
          )
      ),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}