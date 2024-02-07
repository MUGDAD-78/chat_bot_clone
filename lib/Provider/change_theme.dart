import 'package:chat_gpt_clone/constant/themes.dart';
import 'package:flutter/material.dart';

class ChangeTheme with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;

  set(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeData == lightTheme) {
      set(_themeData = darkTheme);
    } else {
      set(_themeData = lightTheme);
    }
  }
}