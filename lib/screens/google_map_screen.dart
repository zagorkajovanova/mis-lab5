import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_mis/services/notification_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/exam.dart';

class MapScreen extends StatefulWidget{
  static const String idScreen = "mapScreen";
  final List<Exam> _exams;
  MapScreen(this._exams);

  @override
  _MapScreenState createState() => _MapScreenState(_exams);
}

class _MapScreenState extends State<MapScreen>{
  final NotificationService service = NotificationService();
  final List<Marker> markers = <Marker>[];
  List<Exam> _exams;

  _MapScreenState(this._exams);
  
  @override
  void initState() {
    super.initState();
    _setMarkers(_exams);
  }

  Completer<GoogleMapController> _controller = Completer();
  // set initial location
  static const CameraPosition _kGoogle = CameraPosition(
      target: LatLng(41.9981, 21.4254),
    zoom: 14.4746,
  );


  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  //set markers for all exams
  void _setMarkers(exams) { 
    for(var i=0; i<exams.length; i++) {
      print(exams[i].name);
      markers.add(Marker( 
      markerId: MarkerId(i.toString()),
      position: LatLng(exams[i].location.latitude, exams[i].location.longitude), //position of marker
      infoWindow: InfoWindow( //popup info 
        title: exams[i].name,
        snippet: DateFormat("yyyy-MM-dd HH:mm:ss").format(exams[i].date),
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    }
    print("Number of markers created: " + markers.length.toString());
  }


  // bool _checkIfUserEnteredZone(Position userPosition) {
  //   if(userPosition.latitude >= 42.000894 && userPosition.latitude <= 42.006855 && 
  //      userPosition.longitude >= 21.406468 && userPosition.longitude <= 21.413285) {
  //       return true;
  //   }
  //   print("not in zone");
  //   print(userPosition.latitude);
  //   print(userPosition.longitude);
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    // const oneSec = const Duration(seconds: 10);
    // Timer.periodic(oneSec, (Timer timer) {
    //   print("execute timer task");
    //   getUserCurrentLocation().then((userPosition) {
    //     print("success getting user location");
    //     if(_checkIfUserEnteredZone(userPosition)) {
    //         print("Repeat task every one second");  // This statement will be printed after every one second
    //         service.showNotification(id: 0, title: 'You have upcoming exams', body: 'Check your calendar');
    //     }
    //   });   
    // }); 

    return Scaffold(
      appBar: AppBar(
        // on below line we have given title of app
        title: Text("Google Maps"),
      ),
       body: Container(
        child: SafeArea(
          // on below line creating google maps
          child: GoogleMap(
          //adding marker for every exam location
          markers: Set<Marker>.of(markers),
          initialCameraPosition: _kGoogle,
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
            },
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async{
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() +" "+value.longitude.toString());

            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 16,
            );
 
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
        },
        child: Icon(Icons.center_focus_strong_rounded, color: Colors.black,),
      ),
    );
  }

}

