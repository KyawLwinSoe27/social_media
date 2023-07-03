import 'dart:io';

import 'package:social_media_app/data/vos/user_vo.dart';

abstract class AuthenticationModel {
  Future<void> register(String email, String userName, String password, File? userProfilePicture);
  Future<void> login(String email, String password);
  bool isLoggedIn();
  UserVO getLoggedUser();
  Future<void> logOut();
}