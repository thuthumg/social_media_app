
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/news_feed_bloc.dart';
import 'package:social_media_app/pages/add_new_post_page.dart';
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
          actions: [Icon(Icons.search,color: Colors.grey,)],
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
