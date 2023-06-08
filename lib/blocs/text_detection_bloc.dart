
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/ml_kit/ml_kit_text_recognition.dart';

class TextDetectionBloc extends ChangeNotifier{



  ///Image
  File? chosenImageFile;

 ///MLKit
final MLKitTextRecognition _mlKitTextRecognition = MLKitTextRecognition();

onImageChosen(File imageFile,Uint8List bytes)
{
  chosenImageFile = imageFile;
  _mlKitTextRecognition.detectTexts(imageFile);

  notifyListeners();
}

}