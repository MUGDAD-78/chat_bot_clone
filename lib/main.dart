// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages
import 'package:chat_gpt_clone/Provider/change_theme.dart';
import 'package:chat_gpt_clone/Screens/chat_screen.dart';
import 'package:chat_gpt_clone/Screens/login_screen.dart';
import 'package:chat_gpt_clone/constant/alert_dilog.dart';
import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:chat_gpt_clone/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          child: const MyApp(),
          create: (context) {
            return ChangeTheme();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
Future init(BuildContext context) async {
  await Future.delayed(Duration(seconds: 5));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider.of<ChangeTheme>(
          context,
        ).themeData,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: primaryColor,
              );
            } else if (snapshot.hasError) {
              return showAlertDilog(context, 'Something went wrong',);
            } else if (snapshot.hasData) {
              return ChatScreen();
            } else {
              return LoginScreen();
            }
          },
        ));
  }
}
