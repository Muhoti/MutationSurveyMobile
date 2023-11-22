// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsd_makueni_mobile_app/Components/FootNote.dart';
import 'package:fsd_makueni_mobile_app/Components/ForgetPasswordDialog.dart';
import 'package:fsd_makueni_mobile_app/Components/MyTextInput.dart';
import 'package:fsd_makueni_mobile_app/Components/SubmitButton.dart';
import 'package:fsd_makueni_mobile_app/Components/TextResponse.dart';
import 'package:fsd_makueni_mobile_app/Components/Utils.dart';
import 'package:fsd_makueni_mobile_app/Pages/Home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String error = '';
  String email = '';
  String password = '';
  var isLoading;
  final storage = const FlutterSecureStorage();

  verifyUser(token) async {
    var token = await storage.read(key: "mljwt");
    var decoded = parseJwt(token.toString());

    if (decoded["error"] == "Invalid token") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/bg.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200, // Set the desired width
                        ),
                      ),
                      const Text(
                        'MLIMS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Haven of Opportunities',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                            child: Column(
                              children: [
                                Form(
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                      const Text(
                                        'Login',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Color.fromARGB(
                                                255, 26, 114, 186),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextResponse(label: error),
                                      MyTextInput(
                                        title: 'Email Address',
                                        lines: 1,
                                        value: '',
                                        type: TextInputType.emailAddress,
                                        onSubmit: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                      ),
                                      MyTextInput(
                                        title: 'Password',
                                        lines: 1,
                                        value: '',
                                        type: TextInputType.visiblePassword,
                                        onSubmit: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Forgot Password?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Show the ForgetPasswordDialog when the "Forget Password" link is clicked.
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const ForgetPasswordDialog(),
                                              );
                                            },
                                            child: const Text(
                                              'Click Here',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SubmitButton(
                                        label: "Submit",
                                        onButtonPressed: () async {
                                          setState(() {
                                            isLoading = LoadingAnimationWidget
                                                .staggeredDotsWave(
                                              color: const Color.fromARGB(
                                                  255, 26, 114, 186),
                                              size: 100,
                                            );
                                          });
                                          print("login beginning");
                                          print("the error is $error");
                                          var res =
                                              await login(email, password);
                                          setState(() {
                                            isLoading = null;
                                            if (res.error == null) {
                                              error = res.success;
                                            } else {
                                              error = res.error;
                                            }
                                          });
                                          if (res.error == null) {
                                            print("token stored");
                                            await storage.write(
                                                key: 'mljwt', value: res.token);
                                            // PROCEED TO NEXT PAGE
                                            verifyUser(res.token);
                                          }
                                        },
                                      ),
                                    ]))),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(alignment: Alignment.bottomLeft, child: FootNote())
                ],
              ),
            ),
          ),
        ),
      );
  }
}

Future<Message> login(String email, String password) async {
  if (email.isEmpty || !EmailValidator.validate(email)) {
    return Message(
      token: null,
      success: null,
      error: "Email is invalid!",
    );
  }

  if (password.length < 6) {
    return Message(
      token: null,
      success: null,
      error: "Password is too short!",
    );
  }

  try {
    final response = await http.post(
      Uri.parse("${getUrl()}mobile/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'Email': email, 'Password': password}),
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
