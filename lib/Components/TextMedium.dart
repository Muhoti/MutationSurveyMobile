import 'package:flutter/material.dart';

class TextMedium extends StatefulWidget {
  final String label;
  const TextMedium({super.key, required this.label});

  @override
  State<TextMedium> createState() => _TextMediumState();
}

class _TextMediumState extends State<TextMedium> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Text(widget.label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 135, 61),
      ),),
    );
  }
}
