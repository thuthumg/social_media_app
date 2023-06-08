
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/news_feed_bloc.dart';
import 'package:social_media_app/pages/add_new_post_page.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/pages/text_detectioon_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/viewitems/news_feed_each_item_widget.dart';

class NewsFeedPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (context) => NewsFeedBloc(),
        child:
        Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Social",
              style: TextStyle(
              color: Color.fromRGBO(85, 85, 85, 1),
              fontSize: 25,
              fontWeight: FontWeight.w600)),
          actions: [
            GestureDetector(
                onTap: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TextDetectionPage(

                  )));
                },
                child: Image.asset("assets/images/text_detect_icon.png")),
            Icon(Icons.search,color: Colors.grey,),
          SizedBox(width: 10,),
          Consumer<NewsFeedBloc>(
            builder: (context,bloc,child)=> GestureDetector(
                onTap: (){
                  bloc.onTapLogout().then((_) => navigationToScreen(context,LoginPage()));
                },
                child: Container(
                    padding: EdgeInsets.only(right: MARGIN_LARGE),
                    child: Icon(Icons.logout,color: Colors.red,size: MARGIN_LARGE,))),
          )
          ],
        ),
        body: Consumer<NewsFeedBloc>(
          builder: (context,bloc,child)=>
          ListView.builder(
            itemCount: bloc.newsfeed?.length??0,
            itemBuilder: (BuildContext context, int index) {
              return NewsFeedEachItemWidget(
                  newsFeedVO: bloc.newsfeed?[index],
              onTapDelete: (newsFeedId){
                bloc.onTapDeletePost(newsFeedId);
              },
              onTapEdit:(newsFeedId){
                Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                  _navigateToEditPostPage(context, newsFeedId);
                });
              }
              );
            },
          ),
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed callback logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewPostPage()),
              );

              // FirebaseCrashlytics.instance.crash();

            },
            child: Icon(Icons.add),
          ),

      )
    );
  }

}

void _navigateToEditPostPage(BuildContext context, int newsFeedId) {

  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddNewPostPage(
    newsFeedId: newsFeedId
  )));
}
