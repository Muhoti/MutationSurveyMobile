import 'package:flutter/material.dart';
import 'package:fsd_makueni_mobile_app/Components/TextOakar.dart';
import 'package:fsd_makueni_mobile_app/Components/TextSmall.dart';

class FootNote extends StatelessWidget {
  FootNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40), // Circular right side
            bottomRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0, // Spread radius set to 0
              blurRadius: 7,
              offset: const Offset(4, 4), // Shadow offset for bottom and right
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: const [
              Text(
                'Powered By',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                'Oakar Services Ltd',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
