import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class CloudFirestoreDataAgentImpl extends SocialDataAgent{
  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    // TODO: implement addNewPost
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(int postId) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    // TODO: implement getNewsFeed
    throw UnimplementedError();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    // TODO: implement getNewsFeedById
    throw UnimplementedError();
  }
  
}