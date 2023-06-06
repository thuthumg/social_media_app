import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/register_bloc.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/label_and_textfield_view.dart';
import 'package:social_media_app/widgets/loading_view.dart';
import 'package:social_media_app/widgets/or_view.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> RegisterBloc(),
      child: Scaffold(
        body: Selector<RegisterBloc,bool>(
          selector: (context,bloc)=>bloc.isLoading,
          builder:(context,isLoading,child) =>SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MARGIN_LARGE,
                      bottom: MARGIN_LARGE,
                      left: MARGIN_XLARGE,
                      right: MARGIN_XLARGE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: TEXT_BIG),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context,bloc,child)=> LabelAndTextFieldView(
                          label: "Email",
                          hint: "Please enter your email",
                          onChanged: (email) {
                            bloc.onEmailChanged(email);
                          },
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context,bloc,child)=> LabelAndTextFieldView(
                            label: "User Name",
                            hint: "Please enter your user name",
                            onChanged: (userName) {
                              bloc.onUserNameChanged(userName);
                            }
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context,bloc,child)=> LabelAndTextFieldView(
                            label: "Password",
                            hint: "Please enter your password",
                            onChanged: (password) {
                              bloc.onPasswordChanged(password);
                            },
                          isSecure:true
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      ProfileImageView(),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context,bloc,child)=> TextButton(
                          onPressed: () {
                            bloc.onTapRegister()
                                .then((_) =>Navigator.pop(context))
                                .catchError((error)=>showSnackBarWithMessage(context, error.toString()));
                          },
                          child: const PrimaryButtonView(
                              label: 'Register'
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      ORView(),
                      SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      LoginTriggerView()
                    ],
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black12,
                    child: Center(
                      child: LoadingView(),
                    ),
                  ),)

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class LoginTriggerView extends StatelessWidget {
  const LoginTriggerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?"),
        SizedBox(width: MARGIN_SMALL,),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Text("Login",style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline)),
        )
      ],
    );
  }
}

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterBloc>(
      builder: (context, bloc, child) => Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [


            Container(
              child: (bloc.chosenImageFile == null)
                  ? GestureDetector(
                child: SizedBox(
                  height: 100,
                  child:
                  Center(child: Image.asset("assets/images/empty_photo.png",fit: BoxFit.cover,scale: 10,)),
                ),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) {
                    bloc.onImageChosen(File(image.path));
                  }
                },
              )
                  : SizedBox(
                height: 100,
                child: Image.file(
                  bloc.chosenImageFile ?? File(""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: bloc.chosenImageFile != null,
                child: GestureDetector(
                  onTap: (){
                    bloc.onTapDeleteImage();
                  },
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}