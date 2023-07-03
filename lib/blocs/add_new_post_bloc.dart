import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/model/authentication_model_impl.dart';
import 'package:social_media_app/data/model/social_media_model.dart';
import 'package:social_media_app/data/model/social_media_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/remote_config/firebase_remote_config.dart';

class AddNewPostBloc extends ChangeNotifier{
  String description = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  Color themeColor = Colors.black;

  /// for edit mode
  bool isEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? newsFeed;
  bool isLoading = false;
  UserVO? loggedInUser;

  /// Image Related Var
  File? chooseImageFile;

  /// Model
  final SocialMediaModel socialMediaModel = SocialMediaModelImpl();
  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  /// Remote Config
  final FirebaseRemoteConf firebaseRemoteConf = FirebaseRemoteConf();

  AddNewPostBloc({int? newsFeedId}) {
    /// add new post စခေါ်တာနဲ့ထည့်ပေးဖို့လိုမယ်
    loggedInUser = authenticationModel.getLoggedUser();
    if(newsFeedId != null) {
      isEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }

    _sendAnalyticsData(addNewPostScreenReached, null);
    _getThemeColorFromRemoteConfig();
  }

  _sendAnalyticsData(String name, Map<String,dynamic>? parameters) async {
    return FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  _getThemeColorFromRemoteConfig() {
    themeColor = firebaseRemoteConf.getThemeColorFromRemoteConfig();
    _notifySafety();
  }


  void onNewPostTextChanged(String postDescription) {
    description = postDescription;
  }

  Future onTapAddNewPost() {
    if(description.isEmpty) {
      isAddNewPostError = true;
      _notifySafety();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafety();
      if(isEditMode)  {
        return _editNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafety();
          _sendAnalyticsData(editPostAction, {postId : newsFeed?.id.toString()});
        });
      } else {
        return _createNewPost().then((value) {
          isLoading = false;
          _notifySafety();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
    }
  }

  Future<dynamic> _editNewsFeedPost() {
    newsFeed?.description = description;
    if(newsFeed != null) {
      return socialMediaModel.editPost(newsFeed!, chooseImageFile);
    }else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewPost() {
    return socialMediaModel.addNewPost(description,chooseImageFile);
  }

  void _prepopulateDataForAddNewPost() {
    userName = loggedInUser?.userName ?? "";
    profilePicture = loggedInUser?.profilePicture ?? "https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg";
    _notifySafety();
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    socialMediaModel.getNewsFeedById(newsFeedId).listen((newsFeed) async {
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      description = newsFeed.description ?? "";
      this.newsFeed = newsFeed;
      _notifySafety();
    });
  }

  void onImageChosen(File imageFile) {
    chooseImageFile = imageFile;
    _notifySafety();
  }

  void onTapDeleteImage() {
    chooseImageFile = null;
    _notifySafety();
  }

  void _notifySafety() {
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}