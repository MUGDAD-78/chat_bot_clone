import 'package:chat_gpt_clone/Firebase/firebase_auth_services.dart';
import 'package:chat_gpt_clone/Screens/register_screen.dart';
import 'package:chat_gpt_clone/constant/button_style.dart';
import 'package:chat_gpt_clone/constant/common.dart';
import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:chat_gpt_clone/constant/text_filed_decoration.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isloading = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Log in your account ",
                    style: Common().titelTheme,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextField(
                            controller: emailController,
                            decoration: textFiledDecoration.copyWith(
                              hintText: 'Email',
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: textFiledDecoration.copyWith(
                              hintText: 'Password',
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _isloading
                            ? ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isloading = false;
                                  });
                                  await FirebaseAuthServices().login(
                                      emial: emailController.text,
                                      password: passwordController.text,
                                      context: context);
                                  setState(() {
                                    _isloading = true;
                                  });
                                },
                                style: buttonStyle,
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: primaryColor,
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: Common().hinttext,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Register Now",
                            style: Common().mediumTheme,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
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
      ),
    );
  }
}
