import 'package:flutter/material.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class AddNewPostBloc extends ChangeNotifier {
  ///State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;

  ///For Edit Mode
  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  ///Model
  final SocialModel _model = SocialModelImpl();

  AddNewPostBloc({int? newsFeedId}) {
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isAddNewPostError = false;
      if(isInEditMode){
        return _editNewsFeedPost();
      }else{
        return _createNewNewsFeedPost();
      }

    }
  }

  Future<dynamic> _editNewsFeedPost(){
    mNewsFeed?.description = newPostDescription;
    if(mNewsFeed != null){
      return _model.editPost(mNewsFeed!);
    }else{
      return Future.error("Error");
    }

  }
  Future<void> _createNewNewsFeedPost(){
    return _model.addNewPost(newPostDescription);
  }
  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeedData) {
      userName = newsFeedData.userName ?? "";
      profilePicture = newsFeedData.profilePicture ?? "";
      newPostDescription = newsFeedData.description ?? "";
      mNewsFeed = newsFeedData;
      _notifySafely();
    });
  }

  void _prepopulateDataForAddNewPost() {
    userName = "Thu Thu";
    profilePicture = "assets/images/profile_img3.jpg";
    _notifySafely();
  }
}
