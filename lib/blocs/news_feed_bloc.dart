import 'package:flutter/material.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier{

  List<NewsFeedVO>? newsfeed;

  final SocialModel _mSocialModel = SocialModelImpl();
  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();
  bool isDisposed = false;

  NewsFeedBloc(){
    _mSocialModel.getNewsFeed().listen((newsFeedList) {
      newsfeed = newsFeedList;
      if(!isDisposed)
        {
          notifyListeners();
        }

    });
    _sendAnalyticsData();
  }

  void onTapDeletePost(int postId) async {
    await _mSocialModel.deletePost(postId);
  }

  Future onTapLogout(){
    return _authenticationModel.logout();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
  void _sendAnalyticsData() async {
    await FirebaseAnalyticsTracker().logEvent(homeScreenReached, null);
  }

}