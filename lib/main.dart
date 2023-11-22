// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/FootNote.dart';
import 'package:fsd_makueni_mobile_app/Pages/Home.dart';
import 'package:fsd_makueni_mobile_app/Pages/Login.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  late Position position;
  var long = 0.0, lat = 0.0;

  Future<void> authenticateUser() async {
    var token = await storage.read(key: 'mljwt');
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login()));
    }
  }

  promptUserForLocation() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
         if (permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        storage.write(key: 'haspermission', value: "true");
        // Call getLocation Function on Home page
        //getLocation();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Location is required! You will be logged out. Please turn on your location"),
      ));
     
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      long = position.longitude;
      lat = position.latitude;
    });

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
  }

  @override
  void initState() {
    promptUserForLocation();

    Timer(const Duration(seconds: 3), () {
      authenticateUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makueni LIMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/bg.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 24, 48, 0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 200, // Set the desired width
                      ),
                    ),
                    const Text(
                      'MLIMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Mapping App',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                )),
              ),
              Align(alignment: Alignment.bottomLeft, child: FootNote())
            ],
          ),
        ),
      ),
    );
  }
}
