
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:ui';
import 'package:tflite/tflite.dart';
late List<CameraDescription> cameras;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized(); 
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String appTitle = "ASL Assist";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}




class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late TextEditingController _txtController2;
  late TextEditingController _txtController1;
  //late List<CameraDescription> _cameras;
  //late XFile image;
  late CameraController _camController;
  final FlutterTts _tts = FlutterTts();
  bool _isRunning = false;
  bool _isReady = false;
  late bool _wasRunning;
  bool isInit = false;
  bool _isMute = true;
  bool _isLog = false;
  late bool _wasMute;
  late Timer timer;
  String _words = "";
  String _save = "";
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _txtController1 = TextEditingController();
    _txtController2 = TextEditingController();
    loadLabel();
    _tts.setVolume(0);
    //temporary
    dummy();
    timer.cancel();
    //temporary
    initializeCamera();
    super.initState();
  }

  @override
  void dispose() async{
    WidgetsBinding.instance.removeObserver(this);
    await Tflite.close();
    _camController.dispose();
    _txtController1.dispose();
    _txtController2.dispose();
    super.dispose();
  }

  Future<dynamic> runModel(XFile img)async{
  var recognitions = await Tflite.detectObjectOnImage(path: img.path);
  return recognitions![0]["detectedClass"].toString();
  }

  void loadLabel() async{
    String? res = await Tflite.loadModel(
    model: "assets/model.tflite",
    labels: "assets/label.txt",
    numThreads: 4
  );
}
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_camController == null || !_camController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _camController.dispose();
      _tts.stop();
      //
      timer.cancel();
      //
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    //_cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _camController = CameraController(cameras[0], ResolutionPreset.high,imageFormatGroup: ImageFormatGroup.jpeg);
      isInit
          ? _camController.initialize().then((_) async {
              if (!mounted) {
                return;
              }

              setState(() {
                _isReady = true;
              });
              dummy();

               
              
            })
          : isInit = true;
    }
  }

  void speech(String word) async {
    await _tts.setPitch(0.7);
    await _tts.setSpeechRate(0.4);
    await _tts.speak(word);
  }

//instead of the model
//temporary
  void dummy() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      String frameData = "";
      await _camController.takePicture().then((image)async => frameData = await runModel(image));

      _words.length > 100 ? _words = "" : _;
      _words = "$_words $frameData";
      _save = "$_save $frameData";
      _txtController1.text = _save;
      _txtController2.text = _words;
      speech(frameData);
    });
  }
//temporary


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      onDrawerChanged: (isOpened) {
        setState(() {
          if (isOpened) {
            _isLog = true;
            _wasMute = _isMute;
            _wasRunning = _isRunning;
            _isMute = true;
            _isRunning = false;
          } else {
            _isLog = false;
            _isMute = _wasMute;
            _isRunning = _wasRunning;
          }
          if (!_isRunning) {
            _camController.dispose();
            _tts.stop();
            timer.cancel();
            _isReady = false;
          } else {
            initializeCamera();
          }
        });
      },
      key: _key,
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.white38,
        width: MediaQuery.of(context).size.width * .8,
        child: Stack(
          children: [
            ClipRect(
              clipBehavior: Clip.hardEdge,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 7,
                  sigmaY: 7,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .8 - 50,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 12, left: 10),
                  height: 100,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: const Text(
                    "Interpreted Signs",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _txtController1,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      readOnly: true,
                      maxLines: null,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
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
                    _key.currentState!.openDrawer();

                    setState(
                      () {},
                    );
                  },
                  icon: Icon(Icons.book_outlined,
                      color: _isLog
                          ? const Color.fromARGB(255, 24, 151, 255)
                          : Colors.white24,
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: _isLog
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
                        _isRunning = !_isRunning;
                        if (!_isRunning) {
                          _camController.dispose();
                          _tts.stop();
                          timer.cancel();
                          _isReady = false;
                        } else {
                        initializeCamera();
                        }
                      },
                    );
                  },
                  icon: Icon(Icons.camera_alt_outlined,
                      color: _isRunning ? Colors.yellow : Colors.white24,
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: _isRunning ? Colors.yellow : Colors.transparent,
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
                        
                        _isMute = !_isMute;
                        _isMute ? _tts.setVolume(0) : _tts.setVolume(1);
                      },
                    );
                  },
                  icon: Icon(Icons.volume_up_outlined,
                      color: _isMute
                          ? Colors.white24
                          : const Color.fromARGB(255, 24, 151, 255),
                      size: 24),
                  color: Colors.white24,
                ),
                Positioned(
                  top: 35,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: _isMute
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
            child: !_isReady && _isRunning
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  )
                 :  _isReady && _isRunning
                  ? CameraPreview(_camController)
                     : 
                     Center(
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
                      controller: _txtController2,
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
                        0.2,
                        0.40,
                        0.60,
                        0.9,
                      ],
                      colors: [
                        Colors.transparent,
                        Colors.white12,
                        Colors.white54,
                        Colors.white70,
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    //
                  ),
                  /* child: image != null? Container(height: 20,width: 20, color: Colors.red,
                    child: Image.file(image!)):const SizedBox(),  */
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
