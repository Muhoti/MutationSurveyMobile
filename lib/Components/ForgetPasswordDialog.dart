import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MyTextInput.dart';
import 'package:fsd_makueni_mobile_app/Components/SubmitButton.dart';
import 'package:fsd_makueni_mobile_app/Components/TextResponse.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordDialog extends StatefulWidget {
  const ForgetPasswordDialog({super.key});

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  String email = '';
  var isLoading;
  String error = '';
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 24, color: Color.fromARGB(255, 26, 114, 186))),
            TextResponse(label: error),
            MyTextInput(
              title: 'Email',
              lines: 1,
              value: '',
              type: TextInputType.emailAddress,
              onSubmit: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SubmitButton(
              label: "Submit",
              onButtonPressed: () async {
                setState(() {
                  isLoading = LoadingAnimationWidget.staggeredDotsWave(
                    color: Color.fromRGBO(0, 128, 0, 1),
                    size: 100,
                  );
                });
                var res = await recoverPassword(email);
                setState(() {
                  isLoading = null;
                  if (res.error == null) {
                    error = res.success;
                  } else {
                    error = res.error;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<Message> recoverPassword(String email) async {
  if (email.isEmpty || !EmailValidator.validate(email)) {
    return Message(
      token: null,
      success: null,
      error: "Please Enter Your Email",
    );
  }

  try {
    final response = await http.post(
      Uri.parse("${getUrl()}auth/forgot"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'Email': email}),
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
