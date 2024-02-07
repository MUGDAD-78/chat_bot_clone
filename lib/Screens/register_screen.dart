// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:chat_gpt_clone/Firebase/firebase_auth_services.dart';
import 'package:chat_gpt_clone/constant/alert_dilog.dart';
import 'package:chat_gpt_clone/constant/button_style.dart';
import 'package:chat_gpt_clone/constant/common.dart';
import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:chat_gpt_clone/constant/text_filed_decoration.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  String _password = '';

  // ignore: unused_field
  String _confirmPassword = '';

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello! Register to get  ",
                      style: Common().titelTheme,
                    ),
                    Text(
                      "started",
                      style: Common().titelTheme,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "This filed is required";
                          }
                          return null;
                        },
                        decoration: textFiledDecoration.copyWith(
                          hintText: "Username",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        obscureText: false,
                        validator: (value) {
                          return value!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : "Enter a valid email";
                        },
                        decoration:
                            textFiledDecoration.copyWith(hintText: 'Email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Password is required please enter';
                          }
                          // you can check password length and specifications
                          if (value!.length < 8) {
                            return "Password must be atleast 8 characters long";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration:
                            textFiledDecoration.copyWith(hintText: 'Password'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Conform password is required please enter';
                          }
                          if (value != _password) {
                            return 'Confirm password not matching';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: textFiledDecoration.copyWith(
                            hintText: 'Confirm Password'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isLoading
                          ? ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  await FirebaseAuthServices().register(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context,
                                      username: usernameController.text);

                                  setState(() {
                                    isLoading = true;
                                  });
                                } else {
                                  showAlertDilog(
                                      context, "Something wrong happened");
                                }
                              },
                              style: buttonStyle,
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'font2'),
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: Image.asset(
                  'assets/img/splash_screen_icon.png',
                  height: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
