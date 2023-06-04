import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialModel{
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(String description);
  Future<void> deletePost(int postId);
  Future<void> editPost(NewsFeedVO newsFeedVO);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
}