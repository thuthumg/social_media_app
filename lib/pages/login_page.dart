import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/login_bloc.dart';
import 'package:social_media_app/pages/news_feed_page.dart';
import 'package:social_media_app/pages/register_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/label_and_textfield_view.dart';
import 'package:social_media_app/widgets/loading_view.dart';
import 'package:social_media_app/widgets/or_view.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> LoginBloc(),
      child: Scaffold(
        body: Selector<LoginBloc,bool>(
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
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: TEXT_BIG),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<LoginBloc>(
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
                      Consumer<LoginBloc>(
                        builder: (context,bloc,child)=> LabelAndTextFieldView(
                          label: "Password",
                          hint: "Please enter your password",
                          onChanged: (password) {
                            bloc.onPasswordChanged(password);
                          },
                          isSecure: true
                        ),
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<LoginBloc>(
                        builder: (context,bloc,child)=> TextButton(
                          onPressed: () {
                            bloc.onTapLogin()
                                .then((_) =>navigationToScreen(context, NewsFeedPage()))
                                .catchError((error)=>showSnackBarWithMessage(context, error.toString()));
                          },
                          child: const PrimaryButtonView(
                            label: 'Login'
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
                      RegisterTriggerView()
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

class RegisterTriggerView extends StatelessWidget {
  const RegisterTriggerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        SizedBox(width: MARGIN_SMALL,),
        GestureDetector(
          onTap: (){
           return navigationToScreen(
              context,
              RegisterPage()
            );
          },
          child: Text("Register",style: TextStyle(
              color: Colors.blue,
          decoration: TextDecoration.underline)),
        )
      ],
    );
  }
}


