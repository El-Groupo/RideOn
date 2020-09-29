import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ride_on/singleton.dart';

class MapDisplay extends StatelessWidget{
  var mySingleton = Singleton();
  static Set<Polyline> _routes = new Set<Polyline>();

  Future<LocationData> getCurrLocation() async {return mySingleton.getCurrLocation();}

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {mapController = controller;}

  @override
  Widget build(BuildContext context){
    return Container(
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width*.95,
        height: MediaQuery.of(context).size.height-200,
      ),
      decoration: BoxDecoration(color: Colors.blue[200]),
      child: FutureBuilder(
        future: getCurrLocation(),
        builder: (context, AsyncSnapshot<LocationData> currLoc) {
//                  var displayLoc;
          if (currLoc.hasData) {
            mySingleton.displayLoc = LatLng(currLoc.data.latitude, currLoc.data.longitude);
            return GoogleMap(
              onMapCreated: _onMapCreated,
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: mySingleton.displayLoc,
                zoom: 17.0,
              ),
              polylines: _routes,
            );
          }
          else {
            return Text(
              "Loading...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),
            );
          }
        },
      ),
    );
  }
}