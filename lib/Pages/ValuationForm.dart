// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ffi';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MySelectInput.dart';
import 'package:fsd_makueni_mobile_app/Components/MyTextInput.dart';
import 'package:fsd_makueni_mobile_app/Components/SubmitButton.dart';
import 'package:fsd_makueni_mobile_app/Components/TextResponse.dart';
import 'package:fsd_makueni_mobile_app/Components/UserContainer.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:fsd_makueni_mobile_app/Pages/Home.dart';
import 'package:fsd_makueni_mobile_app/Pages/MapPage.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ValuationForm extends StatefulWidget {
  const ValuationForm({super.key});

  @override
  State<ValuationForm> createState() => _ValuationFormState();
}

class _ValuationFormState extends State<ValuationForm> {
  var subc = {
    "-Select SubCounty-": [""],
    "Kaiti": ["Ukia", "Kee", "Kilungu", "Ilima"],
    "Kathonzweni": ["Manga", "Kemera", "Magombo"],
    "Kibwezi East": [
      "Masongaleni",
      "Mtito Andei",
      "Thange",
      "Ivingoni/Nzambani"
    ],
    "Kibwezi West": [
      "Emali",
      "Kikumbulyu North",
      "Kikumbulyu South",
      "Makindu",
      "Nguu",
      "Nguumo"
    ],
    "Kilome": ["Ekerenyo", "Itibo", "Bokeira", "Bomwagamo", "Magwagwa"],
    "Makueni": ["Bosamaro", "Township", "Bogichora", "Nyamaiya", "Bonyamatuta"],
    "Mbooni": [
      "Tulimani",
      "Mbooni",
      "Kithungo/Kitundu",
      "Kiteta/Kisau",
      "Waia/Kako",
      "Kalawa"
    ],
    "Nzaui": ["Bosamaro", "Township", "Bogichora", "Nyamaiya", "Bonyamatuta"]
  };

  List<String> wrds = [];

  String id = '';
  String name = '';
  String phone = '';
  String nationalId = '';
  String email = '';
  String subcounty = '';
  String ward = '';
  String market = '';
  String newPlotNo = '';
  String lrno = '';
  String tenure = '';
  String landuse = '';
  String length = '';
  String width = '';
  String area = '';
  String unit = '';
  String rate = '';
  String sitevalue = '';
  String parcelNo = '';
  String propertyId = '';
  String error = '';
  String? editing = '';
  String username = 'username';
  var isLoading;

  final storage = const FlutterSecureStorage();
  dynamic data;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  updateWards(v) {
    setState(() {
      ward = subc[v]!.toList()[0];
      wrds = subc[v]!.toList();
    });
  }

  @override
  void initState() {
    isEditing();

    setState(() {
      var v = subc.keys.toList()[0];
      subcounty = v;
      wrds = subc[v]!.toList();
      ward = subc[v]!.toList()[0];
    });

    super.initState();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  isEditing() async {
    editing = await storage.read(key: "EDITING");
    if (editing == "TRUE") {
      getData();
    } else {}
  }

  getData() async {
    var username1 = await storage.read(key: "UserName");
    username = username1.toString();
    print("user is $username");
    setState(() {
      isLoading = LoadingAnimationWidget.staggeredDotsWave(
        color: const Color.fromARGB(255, 26, 114, 186),
        size: 100,
      );
    });

    try {
      var plotNo = await storage.read(key: "NewPlotNumber");

      print("valuation id is $plotNo");

      print("editing is $editing");

      // Prefill Form
      final response = await get(
        Uri.parse("${getUrl()}valuation/$plotNo"),
      );

      print("current data is ${json.decode(response.body)}");

      var data = json.decode(response.body);
      print("current valuation data is ${data[0]["NewPlotNumber"]}");

      setState(() {
        nationalId = data[0]["NationalID"];
        name = data[0]["OwnerName"];
        phone = data[0]["Phone"];
        email = data[0]["Email"];
        newPlotNo = data[0]["NewPlotNumber"];
        subcounty = data[0]["SubCounty"];
        ward = data[0]["Ward"];
        market = data[0]["Market"];
        lrno = data[0]["LR_Number"]!;
        tenure = data[0]["Tenure"];
        landuse = data[0]["LandUse"];
        length = data[0]["Length"];
        width = data[0]["Width"];
        area = data[0]["Area"];
        unit = data[0]["Unit_of_Area"];
        rate = data[0]["Rate"];
        sitevalue = data[0]["SiteValue"];
        parcelNo = data[0]["ParcelNo"];
        propertyId = data[0]["PropertyID"];
        isLoading = null;
      });

      print("my datas is $data");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle drawer item 1 tap
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Handle drawer item 2 tap
              },
            ),
          ],
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.tightForFinite(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
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
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MapPage()));
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
                      ),
                      const Text(
                        'Valuation Data',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 85, 165)),
                      ),
                      editing == "TRUE"
                          ? Text(
                              'Plot No: $newPlotNo',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                MyTextInput(
                  title: 'Name',
                  lines: 1,
                  value: name,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Phone',
                  lines: 1,
                  value: phone,
                  type: TextInputType.phone,
                  onSubmit: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: isLoading ?? const SizedBox(),
                ),
                MyTextInput(
                  title: 'National ID',
                  lines: 1,
                  value: nationalId,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      nationalId = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Email',
                  lines: 1,
                  value: email,
                  type: TextInputType.emailAddress,
                  onSubmit: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MySelectInput(
                    label: "Sub County",
                    onSubmit: (value) {
                      setState(() {
                        subcounty = value;
                      });
                      updateWards(value);
                    },
                    entries: subc.keys.toList(),
                    value: data == null ? subcounty : data["SubCounty"]),
                const SizedBox(
                  height: 10,
                ),
                MySelectInput(
                    label: "Ward",
                    onSubmit: (value) {
                      setState(() {
                        ward = value;
                      });
                    },
                    entries: wrds,
                    value: data == null ? ward : data["Ward"]),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Market',
                  lines: 1,
                  value: market,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      market = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'New Plot Number',
                  lines: 1,
                  value: newPlotNo,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      newPlotNo = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'LR Number',
                  lines: 1,
                  value: lrno,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      lrno = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MySelectInput(
                    label: "Tenure",
                    onSubmit: (value) {
                      setState(() {
                        tenure = value;
                      });
                    },
                    entries: const ["--Select--", "Free Hold", "Lease Hold"],
                    value: tenure),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Land Use',
                  lines: 1,
                  value: landuse,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      landuse = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Length',
                  lines: 1,
                  value: length,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      length = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Width',
                  lines: 1,
                  value: width,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      width = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Area',
                  lines: 1,
                  value: area,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      area = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MySelectInput(
                    label: 'Unit of Acreage',
                    onSubmit: (value) {
                      setState(() {
                        unit = value;
                      });
                    },
                    entries: const ["--Select--", "Ha", "Acres", "m²"],
                    value: unit),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Rate',
                  lines: 1,
                  value: rate,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      rate = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Site Value',
                  lines: 1,
                  value: sitevalue,
                  type: TextInputType.number,
                  onSubmit: (value) {
                    setState(() {
                      sitevalue = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextInput(
                  title: 'Parcel No',
                  lines: 1,
                  value: parcelNo,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      parcelNo = value;
                    });
                  },
                ),
                MyTextInput(
                  title: 'Property ID',
                  lines: 1,
                  value: propertyId,
                  type: TextInputType.text,
                  onSubmit: (value) {
                    setState(() {
                      propertyId = value;
                    });
                  },
                ),
                Center(
                  child: isLoading ?? const SizedBox(),
                ),
                TextResponse(label: error),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SubmitButton(
                    label: "Submit",
                    onButtonPressed: () async {
                      setState(() {
                        storage.write(key: "EDITING", value: "FALSE");
                        error = "";
                        isLoading = LoadingAnimationWidget.staggeredDotsWave(
                          color: const Color.fromARGB(255, 26, 114, 186),
                          size: 100,
                        );
                      });

                      var res = await submitData(
                          name,
                          phone,
                          nationalId,
                          email,
                          subcounty,
                          ward,
                          market,
                          lrno,
                          newPlotNo,
                          tenure,
                          landuse,
                          length,
                          width,
                          area,
                          unit,
                          rate,
                          sitevalue,
                          parcelNo,
                          propertyId,
                          username!);
                      setState(() {
                        isLoading = null;
                        if (res.error == null) {
                          error = res.success;
                        } else {
                          error = res.error;
                        }
                      });
                      if (res.error == null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<Message> submitData(
    String name,
    String phone,
    String nationalId,
    String email,
    String subcounty,
    String ward,
    String market,
    String plotNo,
    String lrno,
    String tenure,
    String landuse,
    String length,
    String width,
    String area,
    String unit,
    String rate,
    String sitevalue,
    String parcelNo,
    String propertyId,
    String username) async {
  if (name.isEmpty ||
      nationalId.isEmpty ||
      phone.isEmpty ||
      parcelNo.isEmpty ||
      plotNo.isEmpty) {
    return Message(
        token: null, success: null, error: "All Fields Must Be Filled!");
  }

  if (email.isEmpty || !EmailValidator.validate(email)) {
    return Message(
      token: null,
      success: null,
      error: "Email is invalid!",
    );
  }

  print("All fields are required");

  try {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: "mljwt");
    var id = await storage.read(key: "NewPlotNumber");
    var long = await storage.read(key: "long");
    var lat = await storage.read(key: "lat");

    var response;

    print("submitting id is $id");
    var editing = await storage.read(key: "EDITING");

    if (editing == 'TRUE') {
      response = await put(
        Uri.parse("${getUrl()}valuation/update/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!
        },
        body: jsonEncode(<String, dynamic>{
          'SubCounty': subcounty,
          'Ward': ward,
          'Market': market,
          'OwnerName': name,
          'Phone': phone,
          'NationalID': nationalId,
          'Email': email,
          'LR_Number': lrno,
          'NewPlotNumber': plotNo,
          'Tenure': tenure,
          'Longitude': long,
          'Latitude': lat,
          'LandUse': landuse,
          'Length': length,
          'Width': width,
          'Area': area,
          'Unit_of_Area': unit,
          'Rate': rate,
          'SiteValue': sitevalue,
          'ParcelNo': parcelNo,
          'PropertyID': propertyId,
          'FieldOfficer': username
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 203) {
        return Message.fromJson(jsonDecode(response.body));
      } else {
        return Message(
          token: null,
          success: null,
          error: "Connection to server failed!",
        );
      }
    } else {
      response = await post(
        Uri.parse("${getUrl()}valuation/create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!
        },
        body: jsonEncode(<String, dynamic>{
          'OwnerName': name,
          'Phone': phone,
          'NationalID': nationalId,
          'Email': email,
          'SubCounty': subcounty,
          'Ward': ward,
          'Market': market,
          'NewPlotNumber': plotNo,
          'Tenure': tenure,
          'LandUse': landuse,
          'Length': length,
          'Width': width,
          'Area': area,
          'Longitude': long,
          'Latitude': lat,
          'Unit_of_Area': unit,
          'Rate': rate,
          'SiteValue': sitevalue,
          'ParcelNo': parcelNo,
          'PropertyID': propertyId
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 203) {
        return Message.fromJson(jsonDecode(response.body));
      } else {
        return Message(
          token: null,
          success: null,
          error: "Connection to server failed!",
        );
      }
    }
  } catch (e) {
    return Message(
      token: null,
      success: null,
      error: "Connection to server failed!",
    );
  }
}

class Message {
  var token;
  var success;
  var error;

  Message({
    required this.token,
    required this.success,
    required this.error,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      token: json['token'],
      success: json['success'],
      error: json['error'],
    );
  }
}
