import 'dart:io';
import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/model/authentication_model_impl.dart';
import 'package:social_media_app/data/model/social_media_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_media_data_agent.dart';

class SocialMediaModelImpl extends SocialMediaModel {
  static final SocialMediaModelImpl _singleton =
      SocialMediaModelImpl._internal();
  factory SocialMediaModelImpl() {
    return _singleton;
  }
  SocialMediaModelImpl._internal();

  final SocialMediaDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
  // SocialMediaDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description, File? imageFile) {
    if(imageFile != null) {
      return mDataAgent.uploadFileToFirebase(imageFile).then((downloadUrl) {
        return craftNewsFeedVO(description, downloadUrl).then((newPost) {
          return mDataAgent.addNewPost(newPost);
        });
      });
    } else {
      return craftNewsFeedVO(description, "").then((newPost) {
        return mDataAgent.addNewPost(newPost);
      });
    }
  }

  Future<NewsFeedVO> craftNewsFeedVO(String description, String imageUrl) {
    var milliseconds = DateTime.now().microsecondsSinceEpoch;
    var newPost = NewsFeedVO(
        milliseconds,
        description,
        "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg",
        imageUrl,
        authenticationModel.getLoggedUser().userName);
    return Future.value(newPost);
  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return mDataAgent.getNewsFeedById(newsFeedId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed, File? imageFile) {
    if(imageFile != null) {
      return mDataAgent.uploadFileToFirebase(imageFile).then((downloadUrl) {
        return craftEditPost(newsFeed, downloadUrl).then((editPost) => mDataAgent.addNewPost(newsFeed));
      });
    } else {
      return craftEditPost(newsFeed, "").then((editPost) => mDataAgent.addNewPost(editPost));
    }
  }

  Future<NewsFeedVO> craftEditPost(NewsFeedVO newsFeed, String imageUrl) {
    var newPost = NewsFeedVO(newsFeed.id, newsFeed.description,
        newsFeed.profilePicture, imageUrl, newsFeed.userName);
    return Future.value(newPost);
  }
}
