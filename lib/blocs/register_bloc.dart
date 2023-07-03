
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/model/authentication_model_impl.dart';
import 'package:social_media_app/fcm/fcm_service.dart';
import 'package:social_media_app/fcm/fcm_service.dart';

import '../fcm/fcm_service.dart';
import '../fcm/fcm_service.dart';

class RegisterBloc extends ChangeNotifier {
  /// State
  bool isLoading = false;
  String email = "";
  String userName = "";
  String password = "";
  bool obscurePassword = false;
  bool isDisposed = false;
  File? chooseProfilePicture;

  final AuthenticationModel authenticationModel = AuthenticationModelImpl();


  var token = FCMService().listenForMessages();
  Future onTapRegister() {
    showLoading();
    return authenticationModel.register(email, userName, password, chooseProfilePicture).whenComplete(() => hideLoading());
  }


  onEmailChange(String email) {
    this.email = email;
    print(email);
  }

  onUserNameChange(String userName) {
    this.userName = userName;
  }

  onPasswordChange(String password) {
    this.password = password;
  }

  onTapToShowPassword() {
    obscurePassword = !obscurePassword;
    notifySafety();
  }

  void showLoading() {
    isLoading = true;
    notifySafety();
  }

  void hideLoading() {
    isLoading = false;
    notifySafety();
  }

  void onImageChose(File image) {
    chooseProfilePicture = image;
    notifySafety();
  }



  void notifySafety() {
    if(!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}