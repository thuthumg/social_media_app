import 'dart:io';

import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/cloud_firestore_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel{


  static final AuthenticationModelImpl _singleton = AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl(){
    return _singleton;
  }

  AuthenticationModelImpl._internal();

 // SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();

  SocialDataAgent mDataAgent = CloudFirestoreDataAgentImpl();

  @override
  Future<void> register(String email, String userName, String password,File? chosenFile) {

    if(chosenFile != null)
      {

        return mDataAgent.uploadFileToFirebase(chosenFile)
          .then((downloadUrl) =>
         craftUserVO(email, password, userName,downloadUrl))
            .then((user) => mDataAgent.registerNewUser(user));
      }else
        {
          return craftUserVO(email, password, userName,"")
              .then((user) => mDataAgent.registerNewUser(user));
        }



  }

  Future<UserVO> craftUserVO(String email,String password,String userName,String profileImageFile){
    var newUser = UserVO(
        id:"",
        userName:userName,
        email:email,
        password:password,
    profileImageUrl: profileImageFile);
    return Future.value(newUser);
  }

  @override
  Future<void> login(String email, String password) {
   return mDataAgent.login(email, password);
  }

  @override
  UserVO getLoggedInUser() {
    return mDataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return mDataAgent.isLoggedIn();
  }

  @override
  Future<void> logout() {
    return mDataAgent.logOut();
  }

}