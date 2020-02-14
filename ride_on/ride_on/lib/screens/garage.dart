import 'package:flutter/material.dart';

class GarageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage'),
      ),
      drawer: Drawer(
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

                  Navigator.pop(context);  //close drawer
                  //Navigator.of(context).push(MaterialPageRoute(
                  // builder: (BuildContext context) => NewPage("Page two")));
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

                  //Navigator.of(context).push(MaterialPageRoute(
                  // builder: (BuildContext context) => NewPage("Page two")));
                },
              ),
              ListTile(
                title: Text("History"),
                onTap: () {
                  Navigator.pop(context);  //close drawer
                  //Navigator.of(context).push(MaterialPageRoute(
                  // builder: (BuildContext context) => NewPage("Page two")));
                },
              ),
            ]
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Text('Toy Name'),
                Text('Make'),
                Text('Model'),
                Text('Last Ride'),
              ]
            ),
            //garage entries

          ]
        ),
      ),
    );
  }
}