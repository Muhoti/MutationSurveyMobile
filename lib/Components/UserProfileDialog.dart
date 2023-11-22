import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/TextSmall.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';

class UserProfileDialog extends StatefulWidget {
  const UserProfileDialog({super.key});

  @override
  State<UserProfileDialog> createState() => _UserProfileDialogState();
}

class _UserProfileDialogState extends State<UserProfileDialog> {
  String email = '';
  String name = '';
  String nationalId = '';
  String phone = '';
  var isLoading;
  String error = '';
  final storage = const FlutterSecureStorage();

  fetchUser() async {
    var token = await storage.read(key: "mljwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      name = decoded["Name"];
      nationalId = decoded["NationalID"];
      phone = decoded["Phone"];
    });
  }

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "User Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 26, 114, 186),
                ),
              ),
              TextSmall(label: error),
              Text(
                "Name: $name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 26, 114, 186),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Phone: $phone",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 26, 114, 186),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "NationalID: $nationalId",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 26, 114, 186),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // Display the loading animation when it's not null.
            ],
          ),
        ),
      ),
    );
  }
}
