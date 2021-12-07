import 'package:flutter/material.dart';
//translation
import 'package:get/get.dart';

const redColor = Color.fromARGB(255, 237, 103, 97);
const kSendButtonTextStyle = TextStyle(
  color: Color.fromARGB(255, 0, 157, 143),
  fontWeight: FontWeight.bold,
  fontSize: 24.0,
);
const kWelcomeTextStyle = TextStyle(
  color: redColor,
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);

var kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
    hintText: 'Type your message here...'.tr,
    border: InputBorder.none,
    filled: true,
    fillColor: Color.fromARGB(100, 255, 255, 255));

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: redColor, width: 2.0),
  ),
);
const KTextFieldDecoration = InputDecoration(
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const addPostStyle =
    TextStyle(color: redColor, fontSize: 24, fontWeight: FontWeight.bold);
const bloodTypeStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const postTxtBodyStyle = TextStyle(
  fontSize: 20.0,
);
