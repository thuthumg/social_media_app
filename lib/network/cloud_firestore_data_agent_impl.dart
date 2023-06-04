import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///News Feed Collection
const newsFeedCollection = "newsfeed";
class CloudFirestoreDataAgentImpl extends SocialDataAgent{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _firestore
        .collection(newsFeedCollection)
        .doc(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
   return _firestore
       .collection(newsFeedCollection)
       .doc(postId.toString())
       .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    //snapshots => querySnapShot=> querySnapShot.docs => List<QueryDocumentSnapshot> => data()=> List<Map<String, dynamic>> => NewsFeedVO.fromJson => List<NewsFeedVO>
    return _firestore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapShot) {
          return querySnapShot.docs.map<NewsFeedVO>((document){
            return NewsFeedVO.fromJson(document.data());
          }).toList();
    });

  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    // TODO: implement getNewsFeedById
    throw UnimplementedError();
  }
  
}