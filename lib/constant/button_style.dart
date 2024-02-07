import 'package:chat_gpt_clone/constant/primary_color.dart';
import 'package:flutter/material.dart';

final buttonStyle = ButtonStyle(
    side: const MaterialStatePropertyAll(BorderSide(color: Colors.black)),
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    fixedSize: const MaterialStatePropertyAll(Size.fromWidth(370)),
    padding: const MaterialStatePropertyAll(
      EdgeInsets.symmetric(vertical: 20),
    ),
    backgroundColor:  const MaterialStatePropertyAll(primaryColor));
