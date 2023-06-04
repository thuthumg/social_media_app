import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///News Feed Collection
const newsFeedCollection = "newsfeed";
const fileUploadRef = "uploads";

class CloudFirestoreDataAgentImpl extends SocialDataAgent{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var firebaseStorage = FirebaseStorage.instance;

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
    return _firestore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => NewsFeedVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().microsecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }
}