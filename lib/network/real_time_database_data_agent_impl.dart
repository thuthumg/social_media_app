import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///Database Paths
const newsFeedPath = "newsfeed";
const fileUploadRef = "uploads";

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  ///Database
  var databaseRef = FirebaseDatabase.instance.ref();
  var firebaseStorage = FirebaseStorage.instance;

  // @override
  // Stream<List<NewsFeedVO>> getNewsFeed() {
  //   return databaseRef.child(newsFeedPath).onValue.map((event) {
  //
  //     List<Object?> snapshotData = (event.snapshot.value as List<Object?>);
  //     List<Object?> mutableList = List.from(snapshotData);
  //     mutableList.removeAt(0);
  //
  //     print("check value = ${mutableList.length}");
  //     return (mutableList).map<NewsFeedVO>((element) {
  //       return NewsFeedVO.fromJson(Map<String, dynamic>.from(element as Map<dynamic,dynamic>));
  //     }).toList();
  //   });
  // }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(newsFeedPath).onValue.map((event) {
      ///for complex key
      //event.snapshot.value => Map<String,dynamic> => values=> List<Map<String,dynamic>> => NewsFeedVO.fromJson() => List<NewsFeedVO>

      Map<Object?, Object?> objectMap = event.snapshot.value
          as Map<Object?, Object?>; // Replace with the actual object
      Map<String?, dynamic> convertedMap = {};
      // print("check value = ${objectMap.length}");
      objectMap.forEach((key, value) {
        // print("check value 1= ${key.toString()} ${value}");
        convertedMap[key.toString()] = value;
      });
      // print("check value 2= ${convertedMap.values}");

      return (convertedMap.values).map<NewsFeedVO>((element) {
        //print("check value = ${element.length}");
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return databaseRef
        .child(newsFeedPath)
        .child(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsFeedPath).child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeedId.toString())
        .once()
        .asStream()
        .map((snapShot) {
      return NewsFeedVO.fromJson(
          Map<String, dynamic>.from((snapShot.snapshot.value as dynamic)));
    });
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
