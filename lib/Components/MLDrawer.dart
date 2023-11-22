import 'package:fsd_makueni_mobile_app/Components/ChangePasswordDialog.dart';
import 'package:fsd_makueni_mobile_app/Pages/Home.dart';
import 'package:fsd_makueni_mobile_app/Pages/Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class MLDrawer extends StatelessWidget {
  const MLDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 128, 0, 1),
            Color.fromRGBO(0, 128, 0, 1),
          ],
        )),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(child: Image.asset('assets/images/logo.png'))),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) =>  Home()));
              },
            ),
            ListTile(
              title: const Text(
                'Map Farmer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Home(
                            )));
              },
            ),
            ListTile(
              title: const Text(
                'Change Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ChangePasswordDialog();
                  },
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: style,
              ),
              onTap: () {
                final store = new FlutterSecureStorage();
                store.deleteAll();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Login()));
              },
            ),
          ],
        ));
  }
}
