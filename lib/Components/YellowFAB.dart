import 'package:flutter/material.dart';

class YellowButton extends StatefulWidget {
  final String label;
  final onButtonPressed;
  const YellowButton({Key? key, required this.label, this.onButtonPressed})
      : super(key: key);

  @override
  State<YellowButton> createState() => _YellowButtonState();
}

class _YellowButtonState extends State<YellowButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 255, 193, 7), // Yellow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
              ),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              elevation: 20, // Shadow elevation
              shadowColor: Colors.black.withOpacity(1)),
          onPressed: widget.onButtonPressed,
          child: Text(
            widget.label,
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 26, 114, 186)),
          )),
    );
  }
}
