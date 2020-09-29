import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ride_on/login_pages/root_page.dart';
import 'package:ride_on/services/authentication.dart';

import 'login_pages/root_page.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
      gcmSenderID: '297855924061',
      apiKey: 'AIzaSyCauKVGVD5ODSuviZRoLjPb7Lf0QaC6nqE',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:297855924061:android:669871c998cc21bd',
      apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'RideOn',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
