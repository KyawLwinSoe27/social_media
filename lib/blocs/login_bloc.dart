
import 'package:flutter/material.dart';
import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/model/authentication_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  /// State Varaible
  bool isLoading = false;
  String email = "";
  String password = "";
  bool isDisposed = false;

  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  Future onTapLogin() {
    showLoading();
    return authenticationModel.login(email, password).whenComplete(() => hideLoading());
  }

  onEmailChange(String email) {
    this.email = email;
  }

  onPasswordChange(String password) {
    this.password = password;
  }

  void showLoading() {
    isLoading = true;
    notifySafety();
  }

  void hideLoading() {
    isLoading = false;
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