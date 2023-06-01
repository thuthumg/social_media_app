import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialDataAgent{
  Stream<List<NewsFeedVO>> getNewsFeed();
}