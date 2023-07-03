import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/social_media_data_agent.dart';

///Database Path
const newsFeedPath = "newsfeed";
const socialMediaImage = "socialMediaImage";
const userPath = "users";
const userProfilePicture = "User_Profile_Picture";

class RealtimeDatabaseDataAgentImpl extends SocialMediaDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }
  RealtimeDatabaseDataAgentImpl._internal();

  /// Database
  var databaseRef = FirebaseDatabase.instance.ref();
  var firebaseStorage = FirebaseStorage.instance;
  var firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(newsFeedPath).onValue.map((event) {
      /// for complex key
      // event.snapshot.value => Map<String,dynamic> => values => List<Map<String,dynamic> => NewsFeedVO.fromJson() => List<NewsFeedVO>
      // dynamic value = event.snapshot.value;
      // if (value is Map<dynamic, dynamic>) {
      //   print(value.values
      //       .map<NewsFeedVO>((e) => NewsFeedVO.fromJson(Map<String, dynamic>.from(e)))
      //       .toList());
      //   return value.values
      //       .map<NewsFeedVO>((e) => NewsFeedVO.fromJson(Map<String, dynamic>.from(e)))
      //       .toList();
      // } else {
      //   return [];
      // }
      // return event.snapshot.value?.values.map<NewsFeedVO>((element) {
      //     return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      //   }).toList();
      Map<Object?, Object?> snapshotValue =
          event.snapshot.value as Map<Object?, Object?>;
      Map<String?, dynamic> convertedMap = {};
      snapshotValue.forEach((key, value) {
        convertedMap[key.toString()] = value;
      });
      return (convertedMap.values).map<NewsFeedVO>((e) {
        //NewsFeedVO type is need to write becz of type cast much, for that, dart can't know type
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newsFeed) {
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeed.id.toString())
        .set(newsFeed.toJson());
  }

  @override
  Future<String> uploadFileToFirebase(File imageFile) {
    return firebaseStorage
        .ref(socialMediaImage)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(imageFile)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsFeedPath).child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeedId.toString())
        .once()
        .asStream()
        .map((snapShot) {
      return NewsFeedVO.fromJson(
        Map<String, dynamic>.from(snapShot.snapshot.value as dynamic),
      );
    });
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return firebaseAuth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) =>
            credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = (user?.uid ?? "");
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return databaseRef
        .child(userPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// to get userData in the application
  @override
  UserVO getLoggedInUser() {
    return UserVO (id: firebaseAuth.currentUser?.uid,email: firebaseAuth.currentUser?.email, userName: firebaseAuth.currentUser?.displayName);
  }

  /// to save in persistence (next to go to Dashboard)
  @override
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> logOut() {
    return firebaseAuth.signOut();
  }

  @override
  Future<String> uploadProfilePictureToFirebase(File imageFile, String userName) {
    return firebaseStorage.ref(userProfilePicture).child("${userName.trim().replaceAll(RegExp(' +'), "_")}_${DateTime.now().millisecondsSinceEpoch}").putFile(imageFile).then((taskSnapShot) => taskSnapShot.ref.getDownloadURL());
  }
}
