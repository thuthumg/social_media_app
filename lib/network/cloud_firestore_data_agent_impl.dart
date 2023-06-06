import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///News Feed Collection
const newsFeedCollection = "newsfeed";
const usersCollection = "users";
const fileUploadRef = "uploads";

class CloudFirestoreDataAgentImpl extends SocialDataAgent{
///Database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ///storage
  var firebaseStorage = FirebaseStorage.instance;

  ///Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

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

  @override
  Future registerNewUser(UserVO newUser) {

   //
   // final userCredential =  auth
   //      .createUserWithEmailAndPassword(
   //      email: newUser.email ?? "",
   //      password: newUser.password ?? "");
   //
   //  userCredential.then((credential) {
   //    return credential.user?..updateDisplayName(newUser.userName);
   //  }
   //  );
   //  userCredential.then((credential) {
   //    return credential.user?..updatePhotoURL(newUser.profileImageUrl);
   //  }
   //  );
   //



    return auth
        .createUserWithEmailAndPassword(
        email: newUser.email ?? "",
        password: newUser.password ?? "")
    .then((credential) {
       credential.user?.updateDisplayName(newUser.userName);
       return credential.user?..updatePhotoURL(newUser.profileImageUrl);
    }
    )
        .then((user) {
      newUser.id = user?.uid ?? "";
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {

    return _firestore
        .collection(usersCollection)
        .doc(newUser.id.toString())
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
        userName: auth.currentUser?.displayName,
        profileImageUrl: auth.currentUser?.photoURL
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