import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';

class RegisterBloc extends ChangeNotifier{

  ///State
  bool isLoading = false;
  String email = "";
  String userName = "";
  String password = "";
  bool isDisposed = false;

  ///Image
  File? chosenImageFile;

  String profilePicture = "";

  ///Model
  final AuthenticationModel _model = AuthenticationModelImpl();

  Future onTapRegister(){
    _showLoading();
    return _model.register(email,userName,password,chosenImageFile).whenComplete(()=>_hideLoading());
  }

  void onEmailChanged(String email){
    this.email = email;
  }
  void onUserNameChanged(String userName){
    this.userName = userName;
  }
  void onPasswordChanged(String password){
    this.password = password;
  }

  void _showLoading(){
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading(){
    isLoading = false;
    _notifySafely();
  }
  void _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }
  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }


  void onImageChosen(File imageFile){
    chosenImageFile = imageFile;
    _notifySafely();
  }

  void onTapDeleteImage(){
    chosenImageFile = null;
    _notifySafely();
  }
}