import 'dart:io';

import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_media_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  static final AuthenticationModelImpl _singleton =
      AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl() {
    return _singleton;
  }

  final SocialMediaDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
  // final SocialMediaDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  AuthenticationModelImpl._internal();
  @override
  Future<void> register(String email, String userName, String password,
      File? userProfilePicture) {
    if (userProfilePicture != null) {
      return mDataAgent
          .uploadProfilePictureToFirebase(userProfilePicture, userName)
          .then((downloadUrl) {
        return craftUserVO(email, userName, password, downloadUrl)
            .then((user) => mDataAgent.registerNewUser(user));
      });
    }
    return craftUserVO(email, userName, password, "")
        .then((user) => mDataAgent.registerNewUser(user));
  }

  Future<UserVO> craftUserVO(
      String email, String userName, String password, String profilePicture) {
    var newUser = UserVO(
        id: "",
        userName: userName,
        email: email,
        password: password,
        profilePicture: profilePicture);

    return Future.value(newUser);
  }

  @override
  Future<void> login(String email, String password) {
    return mDataAgent.login(email, password);
  }

  @override
  UserVO getLoggedUser() {
    return mDataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return mDataAgent.isLoggedIn();
  }

  @override
  Future<void> logOut() {
    return mDataAgent.logOut();
  }
}
