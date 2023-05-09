import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:t2/global.dart';

class Classifier {
  void loadModel() async {
    await Tflite.loadModel(
        model: pathToModel, labels: pathToLabel, numThreads: 2);
  }

  Future<dynamic> runModel(XFile img) async {
    var recognitions = await Tflite.detectObjectOnImage(path: img.path);
    return recognitions![0]["detectedClass"].toString();
  }

  void dispose() async {
    await Tflite.close();
  }
}
