import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

const textFiledDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color.fromARGB(255, 77, 77, 78), width: 2.0),
  ),
  contentPadding: EdgeInsets.all(18),
  // border: InputBorder.none,
  // border: InputBorder.none,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  hintStyle: TextStyle(fontFamily: 'font2'),
);

const chatTextFiledDecoration = InputOptions(
  inputDecoration: InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    hintText: "Ask Something !",
    hintStyle:
        TextStyle(fontFamily: 'font2', color: Color.fromARGB(136, 0, 0, 0)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
  alwaysShowSend: true,
  inputToolbarStyle: BoxDecoration(
    color: primaryColor,
  ),
  cursorStyle: CursorStyle(width: 2),
  inputTextStyle: TextStyle(fontFamily: 'font1'),
);
