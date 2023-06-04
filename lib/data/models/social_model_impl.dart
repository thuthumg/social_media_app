import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel{

  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl(){
    return _singleton;
  }
  SocialModelImpl._internal();

 // SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();

  SocialDataAgent mDataAgent = CloudFirestoreDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description) {

    var currentMilliseconds = DateTime.now().microsecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Thu Thu",
      postImage: "",
      description: description,
      profilePicture: "assets/images/profile_img3.jpg"
    );
    return mDataAgent.addNewPost(newPost);

  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeedVO) {
    return mDataAgent.addNewPost(newsFeedVO);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return mDataAgent.getNewsFeedById(newsFeedId);
  }

}