

import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

class MLKitTextRecognition{

  static final MLKitTextRecognition _singleton = MLKitTextRecognition._internal();

  factory MLKitTextRecognition(){
    return _singleton;
  }

  MLKitTextRecognition._internal();

  void detectTexts(File imageFile) async {
    InputImage inputImage = InputImage.fromFile(imageFile);
    final textDetector = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);
    recognizedText.blocks.forEach((element) {
      print("Recognized Text => ${element.text}");
    });
  }
}