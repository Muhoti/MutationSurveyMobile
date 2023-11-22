import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MySelectInput.dart';
import 'package:fsd_makueni_mobile_app/Components/SubmitButton.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:fsd_makueni_mobile_app/Models/SearchItem.dart';
import 'package:fsd_makueni_mobile_app/Pages/ValuationForm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPlotDetails extends StatefulWidget {
  const SearchPlotDetails({super.key});

  @override
  State<SearchPlotDetails> createState() => _PlotDetailsState();
}

class _PlotDetailsState extends State<SearchPlotDetails> {
  String plotName = '';
  String plotNumber = '';
  String parcelNo = '';

  String searchItem = 'Search';
  String check = '';
  String error = '';
  bool isChecked = false;
  String searchbox = '';
  var si = '';

  final storage = const FlutterSecureStorage();

  List<SearchItem> entries = <SearchItem>[];

  final _scrollController = ScrollController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _keyboardVisibility();
  }

  searchParcel(v) async {
    setState(() {
      entries.clear();
    });
    try {
      dynamic response;

      switch (searchbox) {
        case 'National ID':
          response = await http.get(
              Uri.parse("${getUrl()}valuation/searchid/$v"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8'
              });

          print("searching id: $v");

          break;
        case 'Name':
          response = await http.get(
              Uri.parse("${getUrl()}valuation/searchname/$v"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8'
              });

          print("searching Name: $v");

          break;
        case 'Phone':
          response = await http.get(
              Uri.parse("${getUrl()}valuation/searchphone/$v"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8'
              });

          break;
        case 'Parcel No':
          response = await http.get(
              Uri.parse("${getUrl()}valuation/searchparcel/$v"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8'
              });

          break;
        default:
          'National ID';
          return response;
      }

      var data = json.decode(response.body);
      print("data is $data[0]");
      plotNumber = data[0]["NewPlotNumber"];
      plotName = data[0]["OwnerName"];
      parcelNo = data[0]["ParcelNo"];

      setState(() {
        entries.clear();
        for (var item in data) {
          entries.add(SearchItem(item["NationalID"], item["NewPlotNumber"]));

          switch (searchItem) {
            case 'Name':
              si = item["OwnerName"];

              break;
            case 'National ID':
              si = item["NationalID"];

              break;
            case 'Parcel No':
              si = item["ParcelNo"];

              break;
            case 'Phone':
              si = item["Phone"];

              break;
            default:
          }
          print("THE SEARCH ITEM IS: $si");
        }
      });
    } catch (e) {
      // todo
    }
  }

  addAttribute() {
    storage.write(key: "EDITING", value: "FALSE");
    storage.write(key: "NewPlotNumber", value: "");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ValuationForm()));
  }

  void _keyboardVisibility() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
        if (isKeyboardOpen != _isKeyboardVisible) {
          setState(() {
            _isKeyboardVisible = isKeyboardOpen;
          });
        }
      });
    });
  }

  checkLabel() {
    switch (searchItem) {
      case 'Name':
        setState(() {
          searchbox = 'Name';
        });

        break;
      case 'Phone':
        setState(() {
          searchbox = 'Phone';
        });

        break;
      case 'National ID':
        setState(() {
          searchbox = 'National ID';
        });

        break;
      case 'Parcel No':
        setState(() {
          searchbox = 'Parcel No';
        });
        break;
      default:
    }

    return searchbox;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plot Details',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 85, 165)),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Plot No: $plotNumber",
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(
              height: 5,
            ),
            Text("Approved Parcel No: $parcelNo",
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Search Parcel',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 85, 165)),
            ),
            const SizedBox(
              height: 0,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: MySelectInput(
                      label: 'Select Field',
                      onSubmit: (searchParameter) {
                        setState(() {
                          searchItem = searchParameter;
                        });
                      },
                      entries: const [
                        "Search",
                        "Name",
                        "Phone",
                        "National ID",
                        "Parcel No"
                      ],
                      value: searchItem),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                    child: TextField(
                      onChanged: (value) {
                        if (value.characters.length >=
                            check.characters.length) {
                          searchParcel(value);
                        } else {
                          setState(() {
                            entries.clear();
                          });
                        }
                        setState(() {
                          check = value;
                          error = '';
                        });
                      },
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 26, 114, 186))),
                          filled: false,
                          labelText: checkLabel(),
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 26, 114, 186)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto),
                    ),
                  ),
                )
              ],
            ),
            entries.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Card(
                      elevation: 12,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: entries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  storage.write(
                                      key: "NewPlotNumber",
                                      value: entries[index].NewPlotNumber);
                                  storage.write(key: "EDITING", value: "TRUE");
                                  entries.clear();
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ValuationForm()));
                              },
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('$searchItem: $si')),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                const Text(
                  'No match found?',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SubmitButton(
                label: "New Valuation Record",
                onButtonPressed: () {
                  isChecked
                      ? addAttribute()
                      : () {
                          Fluttertoast.showToast(
                            msg: "Checkbox not checked!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black87,
                            textColor: Colors.black,
                          );
                        };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
