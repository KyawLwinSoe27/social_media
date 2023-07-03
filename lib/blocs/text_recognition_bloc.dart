// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:social_media_app/ml_kit/ml_kit_text_recognition.dart';
//
// class TextRecognitionBloc extends ChangeNotifier {
//   bool isDisposed = false;
//   File? chosenImageFile;
//
//   /// MLKit
//   final MLKitTextRecognition mlKitTextRecognition = MLKitTextRecognition();
//
//   onImageChose(File imageFile, Uint8List bytes) {
//     chosenImageFile = imageFile;
//     mlKitTextRecognition.detectText(imageFile);
//     notifySafety();
//   }
//
//   void notifySafety() {
//     if(!isDisposed) {
//       notifyListeners();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     isDisposed = true;
//   }
// }