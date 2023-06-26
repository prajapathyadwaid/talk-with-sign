import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<String> links = [
  "ikZZHBGoahs",
  "XiyJFuz01PE",
  "Vj_13bdU4dU",
  "tvZ2-fmsogU",
  "wuLrvmDo0og",
  "8Lmb-fNaxAM",
  "ZAX06b_pUxk",
  "2SJbFYqqlxQ",
];

List<String> titles = [
  "Lesson 20 Court in Indian Sign Language By PHIN Deaf",
  "Feeling and Emotion (Indian Sign Language)",
  "Alphabet (Indian Sign Language)",
  "Patient Counselling in Indian Sign Language | Initiative | IPASF |",
  "Rights and laws for empowerment of deaf woman. ( Indian Sign language)",
  "Constitution of India in Indian Sign Language",
  "Indian Sign Language A Linguistic Human Right",
  "Deaf Learn from DEF ISL in Sign language video words voubraby this is very well sign language",
];
List<String> pTitles = [
  "Hello",
  "Goodbye",
  "Thank you",
  "Welcome",
  "Please",
  "Sorry",
  "I love you",
  "Love",
  "Family",
  "House",
  "Yes",
  "No"
];

final GlobalKey<ScaffoldState> key = GlobalKey(); //key for opening and closing the drawer programmatically

bool isInit = false; //to get the available cameras and avoid camera initialization when the app is opened
bool? wasRunning; //to check whether the camera controller was running before opening the drawer
bool? wasMute; //to check whether the tts was on mute or not before the drawer was opened
bool isRunning = false; //to check whether the camera button is pressed or not
bool isReady = false; //to check whether the camera controller is ready
bool isMute = true; //to mute and unmute

late TextEditingController txtController1; //text field on homeScreen
late TextEditingController txtController2; //text field on Drawer
late List<CameraDescription> cameras;

String pathToModel = "assets/ml_model/model.tflite";
String pathToLabel = "assets/ml_model/label.txt";
String drawerWords = "";
String tempWords = "";

late double height; //screen height
late double width; //screen width

Timer? timer;
