
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:t2/functions/textToSpeech.dart';
import 'package:t2/widgets/customDrawer.dart';
import 'package:t2/functions/classifier.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:t2/global.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late CameraController _camController;
  final Speak _tts = Speak();
  final Classifier _classifier = Classifier();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    txtController1 = TextEditingController();
    txtController2 = TextEditingController();
    _classifier.loadModel();
    initializeCamera();
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    txtController1.dispose();
    txtController2.dispose();
    _camController.dispose();
    _classifier.dispose();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_camController == null || !_camController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      //if the app is inactive stop the timer ,dispose the tts and camera
      _camController.dispose();
      _tts.stop();
      timer!.cancel();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

//
  Future<void> initializeCamera() async {
    if (cameras.isNotEmpty) {
      _camController = CameraController(cameras[0], ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg);

      isInit //to get the available cameras and avoid camera initialization when the app is opened
          ? _camController.initialize().then((_) async {
              if (!mounted) return;
              await _camController.setFlashMode(FlashMode.off);
              setState(() {
                isReady = true; //camera is ready and is initialized
              });
              imageStream();
            })
          : isInit = true;
    }
  }


  void imageStream() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      String frameData = "";
      await _camController.takePicture().then((image) async {
        frameData = await _classifier.runModel(image);
        //if the total lenght of the string is more than 100 in the home screen make it ""
        tempWords.length > 100 ? tempWords = "" : _;
        //add the predicted word to the rest of the words
        tempWords = "$tempWords $frameData";
        drawerWords = "$drawerWords $frameData";
        txtController1.text = drawerWords;
        txtController2.text = tempWords;
        await _tts.speak(frameData);
      });
    });
  }

//
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      onDrawerChanged: (isOpened) {
        setState(() {
          if (isOpened) {//save the state of mute and start capture button and turn of evrything
            isDrawer = true;
            wasMute = isMute;
            wasRunning = isRunning;
            isMute = true;
            isRunning = false;
          } else {//after closing the drawer resume the state of controllers
            isDrawer = false;
            isMute = wasMute!;
            isRunning = wasRunning!;
          }
          if (!isRunning ) {//dispose all the controllers when the drawer is opened
            _camController.dispose();
            _tts.stop();
            if(timer != null) timer!.cancel();
            isReady = false; 
          } else {
            initializeCamera();
          }
        });
      },
      key: key,
      backgroundColor: Colors.black,
      drawer: customDrawer(),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    key.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.book_outlined,
                      color: isDrawer
                          ? const Color.fromARGB(255, 24, 151, 255)
                          : Colors.white24,
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: isDrawer
                        ? const Color.fromARGB(255, 24, 151, 255)
                        : Colors.transparent,
                    size: 17,
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isRunning = !isRunning;
                        if (!isRunning) {
                          _camController.dispose();
                          _tts.stop();
                          timer!.cancel();
                          isReady = false;
                        } else {
                          initializeCamera();
                        }
                      },
                    );
                  },
                  icon: Icon(Icons.camera_alt_outlined,
                      color: isRunning ? Colors.yellow : Colors.white24,
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: isRunning ? Colors.yellow : Colors.transparent,
                    size: 17,
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        isMute = !isMute;
                        isMute ? _tts.setVolume(0) : _tts.setVolume(1);
                      },
                    );
                  },
                  icon: Icon(Icons.volume_up_outlined,
                      color: isMute
                          ? Colors.white24
                          : const Color.fromARGB(255, 24, 151, 255),
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: isMute
                        ? Colors.transparent
                        : const Color.fromARGB(255, 24, 151, 255),
                    size: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.width * 1.5,
            width: MediaQuery.of(context).size.width,
            child: !isReady && isRunning
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  )
                : isReady && isRunning
                    ? CameraPreview(_camController)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white38,
                            ),
                            Text("Turn on the Camera ",
                                style: TextStyle(color: Colors.white38)),
                          ],
                        ),
                      ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    //
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: Colors.white,
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      readOnly: true,
                      controller: txtController2,
                      maxLength: 126,
                      decoration: const InputDecoration(
                          border: InputBorder.none, counterText: ""),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0,
                        0.80,
                      ],
                      colors: [
                        Colors.transparent,
                        Colors.white30,   
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    //
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
