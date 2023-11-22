// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextInput extends StatefulWidget {
  String title;
  String value;
  int lines;
  var type;
  Function(String) onSubmit;

  MyTextInput(
      {super.key,
      required this.title,
      required this.lines,
      required this.value,
      required this.type,
      required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != "") {
      setState(() {
        _controller.value = TextEditingValue(
          text: widget.value,
          selection: TextSelection.fromPosition(
            TextPosition(offset: widget.value.length),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: TextField(
            onChanged: (value) {
              setState(() {
                _controller.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                );
              });
              widget.onSubmit(value);
            },
            keyboardType: widget.type,
            controller: _controller,
            maxLines: widget.lines,
            obscureText:
                widget.type == TextInputType.visiblePassword ? true : false,
            enableSuggestions: false,
            autocorrect: false,
            style:
                const TextStyle(color: Color.fromARGB(255, 42, 44, 46)), // Set the text color to white

            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                filled: false,
                label: Text(
                  widget.title.toString(),
                  style: const TextStyle(color: Color.fromARGB(255, 26, 114, 186)),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto)));
  }
}
