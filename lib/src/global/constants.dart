import 'package:flutter/material.dart';

// The localhost Java backend
String backendUri = 'http://10.0.2.2:8080';

const kGreyBackgroundColor = Color(0xFFEBEFF6);
const kBlueBackgroundColor = Color(0xFF3B72F5);
const kOnBlueTextStyle = TextStyle(color: Colors.white, fontSize: 80, fontFamily: "DMSans-Regular.ttf");

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputTextDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.black, fontFamily: "DMSans-Regular.ttf", fontWeight: FontWeight.w500, fontSize: 20),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);


