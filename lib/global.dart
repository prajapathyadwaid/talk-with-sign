import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

final GlobalKey<ScaffoldState> key = GlobalKey();//key for opening and closing the drawer programmatically

bool isInit = false;//to get the available cameras and avoid camera initialization when the app is opened 
bool? wasRunning;//to check whether the camera controller was running before opening the drawer
bool? wasMute;//to check whether the tts was on mute or not before the drawer was opened 
bool isRunning = false;//to check whether the camera button is pressed or not
bool isReady = false;//to check whether the camera controller is ready
bool isDrawer = false;//to check whether the drawer is opened
bool isMute = true;//to mute and unmute

late TextEditingController txtController1;//text field on the homeScreen
late TextEditingController txtController2;//text field on the Drawer
late List<CameraDescription> cameras;

String pathToModel = "assets/model.tflite";
String pathToLabel = "assets/label.txt";
String drawerWords = "";
String tempWords = "";

late double height;//screen height
late double width;//screen width

Timer? timer;