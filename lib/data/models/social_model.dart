import 'dart:io';

import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialModel{
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(String description,File? imageFile);
  Future<void> deletePost(int postId);
  Future<void> editPost(NewsFeedVO newsFeedVO,File? imageFile);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
}