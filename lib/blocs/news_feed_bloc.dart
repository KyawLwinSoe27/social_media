import 'package:flutter/cupertino.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/model/authentication_model.dart';
import 'package:social_media_app/data/model/authentication_model_impl.dart';
import 'package:social_media_app/data/model/social_media_model.dart';
import 'package:social_media_app/data/model/social_media_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  List<NewsFeedVO>? newsFeed;
  UserVO? userVO;

  final SocialMediaModel socialMediaModel = SocialMediaModelImpl();
  final AuthenticationModel authenticationModel = AuthenticationModelImpl();

  bool isDisposed = false;

  NewsFeedBloc() {
    userVO = authenticationModel.getLoggedUser();
    socialMediaModel.getNewsFeed().listen((newsFeedList) {
      newsFeed = newsFeedList;
      if(!isDisposed){
        notifyListeners();
      }
    });

    _sendAnalyticsData();
  }

  _sendAnalyticsData() async {
    return FirebaseAnalyticsTracker().logEvent(homeScreenReached, null);
  }

  onTapDeletePost(int postId, String userName) {
    if(userName == userVO!.userName) {
      socialMediaModel.deletePost(postId);
      notifyListeners();
    }
  }

  Future onTapLogOut() {
    return authenticationModel.logOut();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}