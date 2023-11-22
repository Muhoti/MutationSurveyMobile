import 'package:flutter/material.dart';

class MyFloatingButton extends StatefulWidget {
  final String label;
  final onButtonPressed;
  const MyFloatingButton({Key? key, required this.label, this.onButtonPressed})
      : super(key: key);

  @override
  State<MyFloatingButton> createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FloatingActionButton(
        backgroundColor: Colors.blue, // Yellow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        elevation: 6, // Shadow elevation
        onPressed: widget.onButtonPressed,
        child: Icon(Icons.map, color: Colors.white),
        // child: Text(
        //   widget.label,
        //   style: const TextStyle(
        //       fontSize: 12, color: Color.fromARGB(255, 26, 114, 186)),
        // ),
      ),
    );
  }
}
