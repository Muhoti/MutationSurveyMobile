import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MyMap.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final storage = const FlutterSecureStorage();
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  late Position position;
  var long = null, lat = null;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getUserLocation() async {
    LocationPermission perm = await Geolocator.checkPermission();
    print(perm);
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        long = position.longitude;
        lat = position.latitude;
      });
      
      print("the latitude and long are $lat, $long");

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      );
      
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position position) {
        setState(() {
          long = position.longitude;
          lat = position.latitude;
        });
      });
    } else {
      promptUserForLocation();
    }
  }

  promptUserForLocation() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
    }
  }

  @override
  void initState() {
    promptUserForLocation();
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapPage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: long != null && lat != null
                      ? MyMap(
                          lat: lat,
                          lon: long,
                        )
                      : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
