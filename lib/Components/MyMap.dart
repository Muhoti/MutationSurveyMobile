import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MyDrawer.dart';
import 'package:fsd_makueni_mobile_app/Components/PlotDetailsDialog.dart';
import 'package:fsd_makueni_mobile_app/Components/SearchPlotDetailsDialog.dart';
import 'package:fsd_makueni_mobile_app/Components/UserContainer.dart';
import 'package:fsd_makueni_mobile_app/Components/YellowButton.dart';
import 'package:fsd_makueni_mobile_app/Pages/Home.dart';
import 'package:fsd_makueni_mobile_app/Pages/ValuationForm.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Utils.dart';
import 'dart:io';

class MyMap extends StatefulWidget {
  final double lat;
  final double lon;
  const MyMap({Key? key, required this.lat, required this.lon})
      : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late WebViewController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late Map<String, dynamic> coords;
  // late Map<String, dynamic> data;

  // Modify the below code

  // void setDataFromJavaScript(Map<String, dynamic> newData) {
  //   setState(() {
  //     data = newData;
  //   });

  //   var dataSearch = data["LR_Number"];

  //   if (dataSearch != null) {
  //     print("displayed values are $data");
  //     print("VALUATION ID IS ${data["ValuationID"]}");

  //     if (data["NewPlotNumber"] != null) {
  //       _displayPlotDetailsDialog(data);
  //     } else {
  //       _searchPlotDetailsDialog();
  //     }
  //   }
  // }

  void computePointCoordinates(
      Map<String, dynamic> pointCoords, Map<String, dynamic> receivedData) {
    const storage = FlutterSecureStorage();

    print("compute coordinates: coords is: ${receivedData["NewPlotNumber"]}");

    // setState(() {
    //   coords = pointCoords;
    //   data = receivedData;
    // });

    storage.write(key: "long", value: pointCoords["coordinate"][0].toString());
    storage.write(key: "lat", value: pointCoords["coordinate"][1].toString());

    var newPlotNo = receivedData["NewPlotNumber"];

    print("plot number is $newPlotNo");

    if (newPlotNo != null) {
      _displayPlotDetailsDialog(newPlotNo);
    } else {
      _searchPlotDetailsDialog();
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

// It displays the details of the parcel selected.
  _displayPlotDetailsDialog(newPlotNo) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PlotDetails(
          newPlotNo: newPlotNo,
        );
      },
    );
  }

  void _searchPlotDetailsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const SearchPlotDetails();
      },
    );
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          WebView(
            initialUrl: "${getUrl()}map",
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {
              // JavascriptChannel(
              //   name: 'setDataFromJavaScript',
              //   onMessageReceived: (JavascriptMessage message) {
              //     // Parse the JSON data received from JavaScript
              //     final Map<String, dynamic> receivedData =
              //         jsonDecode(message.message);
              //     print("received data: $receivedData");
              //     // Call the Flutter method to set 'data'
              //     setDataFromJavaScript(receivedData);
              //   },
              // ),
              JavascriptChannel(
                name: 'computePointCoordinates',
                onMessageReceived: (JavascriptMessage message) {
                  // Parse the JSON data received from JavaScript
                  final Map<String, dynamic> computedCoordinate =
                      jsonDecode(message.message);

                  final Map<String, dynamic> receivedData =
                      jsonDecode(message.message);

                  print("current data: $computedCoordinate, $receivedData");
                  // Call the Flutter method to set 'data'
                  computePointCoordinates(computedCoordinate, receivedData);
                },
              ),
            },
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;

              // Call the JavaScript function to adjust the marker.....REMOVE THIS IF NOT NEEDED
              // webViewController.evaluateJavascript(
              //     "adjustMarker('${widget.lon}','${widget.lat}')");
            },
            onPageFinished: (v) {
              // After the page is loaded, call the JavaScript function again .....REMOVE THIS IF NOT NEEDED
              // controller.evaluateJavascript(
              //   "adjustMarker('${widget.lon}','${widget.lat}')",
              // );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Home()));
                  },
                  child: Image.asset(
                    'assets/images/bluearrow.png', // Replace with your image asset
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              UserContainer(),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(24),
          //   child: Align(
          //     alignment: Alignment.bottomRight,
          //     child: YellowButton(
          //       label: "Capture Point",
          //       onButtonPressed: _searchPlotDetailsDialog,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
