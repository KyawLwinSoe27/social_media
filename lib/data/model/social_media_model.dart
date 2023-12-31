import 'dart:io';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialMediaModel {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(String description, File? imageFile);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<void> editPost(NewsFeedVO newsFeed, File? imageFile);
}