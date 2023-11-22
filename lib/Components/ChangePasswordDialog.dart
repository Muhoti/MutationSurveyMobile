import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/MyTextInput.dart';
import 'package:fsd_makueni_mobile_app/Components/SubmitButton.dart';
import 'package:fsd_makueni_mobile_app/Components/TextSmall.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ChangePasswordDialog> {
  String email = '';
  String oldpassword = '';
  String newpassword = '';
  var isLoading;
  String error = '';
  final storage = const FlutterSecureStorage();

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
                "Change Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 26, 114, 186),
                ),
              ),
              TextSmall(label: error),
              MyTextInput(
                title: 'Old Password',
                lines: 1,
                value: '',
                type: TextInputType.visiblePassword,
                onSubmit: (value) {
                  setState(() {
                    oldpassword = value;
                  });
                },
              ),
              MyTextInput(
                title: 'New Password',
                lines: 1,
                value: '',
                type: TextInputType.visiblePassword,
                onSubmit: (value) {
                  setState(() {
                    newpassword = value;
                  });
                },
              ),
              isLoading ??
                  const SizedBox(), // Display the loading animation when it's not null.
              SubmitButton(
                label: "Submit",
                onButtonPressed: () async {
                  setState(() {
                    isLoading = LoadingAnimationWidget.staggeredDotsWave(
                      color: Color.fromRGBO(0, 128, 0, 1),
                      size: 100,
                    );
                  });
                  var res =
                      await changePassword(storage, oldpassword, newpassword);
                  setState(() {
                    isLoading = null;
                    if (res.error == null) {
                      error = res.success;
                      Timer(const Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      error = res.error;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Message> changePassword(FlutterSecureStorage storage, String oldpassword,
    String newpassword) async {
  if (oldpassword.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "Enter Old Password",
    );
  }

  if (newpassword.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "Enter New Password",
    );
  }

  try {
    var token = await storage.read(key: "mljwt");
    var decoded = parseJwt(token.toString());

    var id = decoded["UserID"];
    print("change password id is $id");

    final response = await http.put(
      Uri.parse("${getUrl()}mobile/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Password': oldpassword,
        'NewPassword': newpassword
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
