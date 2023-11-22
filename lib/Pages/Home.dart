// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/BlueBox.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fsd_makueni_mobile_app/Components/MyDrawer.dart';
import 'package:fsd_makueni_mobile_app/Components/MyFloatingButton.dart';
import 'package:fsd_makueni_mobile_app/Components/UserContainer.dart';
import 'package:fsd_makueni_mobile_app/Components/UserProfileDialog.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:fsd_makueni_mobile_app/Components/YellowButton.dart';
import 'package:fsd_makueni_mobile_app/Pages/MapPage.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = const FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String total = '';
  String markets = '';
  String subcounties = '';
  String wards = '';
  dynamic data;
  String username = '';
  List<dynamic> subcountyList = [];

  List<dynamic> wardList = [];

  List<FlSpot> subcountyData = [];
  List<FlSpot> wardData = [];

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  fetchUser() async {
    var token = await storage.read(key: "mljwt");
    var decoded = parseJwt(token.toString());

    print("decoded $decoded");

    setState(() {
      username = decoded["Name"];
      storage.write(key: "UserName", value: username);
    });

    getStats(username);
    loadChartData(username);
  }

  Future<void> loadChartData(String username) async {
    try {
      try {
        final response = await get(
          Uri.parse("${getUrl()}valuation/stats/$username"),
        );

        var data = await json.decode(response.body);
        print("graph data is $data");

        setState(() {
          subcountyList = data["subcounties"];
          wardList = data["wards"];
          print("subcounties are $subcountyList and wards are $wardList");
        });

        // Populate subcounty data
        subcountyData = subcountyList.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final count = double.parse(entry.value["count"]!);
          final subcounty = entry.value["SubCounty"];

          print('Subcounty values are:$index, $count, $subcounty');

          return FlSpot(index, count);
        }).toList();

        // Populate ward data
        wardData = wardList.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final count = double.parse(entry.value["count"]!);
          final ward = entry.value["Ward"];

          print('Wards values are:$index, $count, $ward');

          return FlSpot(index, count);
        }).toList();
      } catch (e) {
        print(e);
      }
    } catch (e) {}
  }

  getStats(String username) async {
    try {
      // Prefill Form
      try {
        print("the name is $username");
        final response = await get(
          Uri.parse("${getUrl()}valuation/topstats/$username"),
        );

        var data = await json.decode(response.body);
        print("stats data is $data");

        setState(() {
          total = data["Allplots"];
          markets = data["Markets"];
          wards = data["Wards"];
          subcounties = data["Subcounties"];
        });
      } catch (e) {
        print(e);
      }
    } catch (e) {}
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _openUserProfileDialog() {
    showDialog(
      context: context,
      builder: (_) =>
          const UserProfileDialog(), // Create an instance of the dialog
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      floatingActionButton: YellowButton(
          label: 'Start Mapping',
          onButtonPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const MapPage()))),
      body: Container(
        constraints: const BoxConstraints.tightForFinite(),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: _openDrawer,
                        child: Image.asset(
                          'assets/images/menuicon.png', // Replace with your image asset
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: _openUserProfileDialog, child: UserContainer()),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 26, 114, 186),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 42, 45, 48),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: BlueBox(total: total, name: "Mapped Plots"),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: BlueBox(total: markets, name: "Markets"),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: BlueBox(total: wards, name: "Wards"),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: BlueBox(total: subcounties, name: "Sub Counties"),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'SubCounties',
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 26, 114, 186),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (subcountyList.isNotEmpty) {
                              final index = value
                                  .toInt()
                                  .clamp(0, subcountyList.length - 1);

                              return Text(subcountyList[index.toInt()]
                                      ["SubCounty"] ??
                                  "");
                            } else
                              return Text("");
                          },
                        )),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true),
                      minX: 0,
                      minY: 0,
                      maxY: 10,
                      lineBarsData: [
                        LineChartBarData(
                          spots: subcountyData,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Wards',
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 26, 114, 186),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (wardList.isNotEmpty) {
                              final index =
                                  value.toInt().clamp(0, wardList.length - 1);

                              return Text(
                                  wardList[index.toInt()]["Ward"] ?? "");
                            } else {
                              return const Text("");
                            }
                          },
                        )),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      gridData: FlGridData(show: true),
                      minX: 0,
                      minY: 0,
                      maxY: 10,
                      maxX: 4,
                      lineBarsData: [
                        LineChartBarData(
                          spots: subcountyData,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: MyFloatingButton(
        //     label: "Start Mapping",
        //     onButtonPressed: () {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (_) => const MapPage()));
        //     },
        //   ),
        // ),
      ),
    );
  }
}
