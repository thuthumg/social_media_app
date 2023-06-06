import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///Database Paths
const newsFeedPath = "newsfeed";
const fileUploadRef = "uploads";
const usersPath = "users";

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  ///Database
  var databaseRef = FirebaseDatabase.instance.ref();

  ///Storage
  var firebaseStorage = FirebaseStorage.instance;

 ///Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

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

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
        email: newUser.email ?? "",
        password: newUser.password ?? "")
        .then((credential) => credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
          newUser.id = user?.uid ?? "";
          _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {

    return databaseRef
        .child(usersPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);

  }

  @override
  UserVO getLoggedInUser() {
    return UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName
    );
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  Future logOut() {
    return auth.signOut();
  }

}

