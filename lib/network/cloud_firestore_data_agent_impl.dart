import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/social_media_data_agent.dart';

const newsFeedCollection = "newsfeed";
const socialMediaImage = "socialMediaImage";
const userPath = "users";

class CloudFireStoreDataAgentImpl extends SocialMediaDataAgent {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> deletePost(int postId) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    // SnapShot => querySnapShot => querySnapShot.docs => List<QueryDocumentSnapShot> => data() => List<Map<String,dynamic>> => NewsFeedVO.fromJson => NewsFeedVO
    return _firestore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<NewsFeedVO>((document) {
        // ဒီဘက်ကလက်ခံမယ့် object ထည့်ထားတယ် generateType အနေနဲ့ | document သည် queryDocumentSnapshot ဖြစ်သည် |
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) =>
            NewsFeedVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<void> addNewPost(NewsFeedVO newsFeed) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(newsFeed.id.toString())
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
  Future registerNewUser(UserVO newUser) {
    return firebaseAuth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) =>
            credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid;
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return _firestore
        .collection(userPath)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  UserVO getLoggedInUser() {
    // TODO: implement getLoggedInUser
    throw UnimplementedError();
  }

  @override
  bool isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfilePictureToFirebase(File imageFile, String userId) {
    // TODO: implement uploadProfilePictureToFirebase
    throw UnimplementedError();
  }
}
