import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/add_new_post_bloc.dart';

class AddNewPostPage extends StatelessWidget {

final int? newsFeedId;

AddNewPostPage({
  this.newsFeedId
});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsFeedId: newsFeedId),
      child:
      Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Text(
              (newsFeedId == null) ? "Add New Post" : "Edit Post",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            )),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: const [
                ProfilePicAndProfileNameSection(),
                SizedBox(height: 10,),
                DescriptionSection(),
                SizedBox(height: 10,),
                PostDescriptionErrorSection(),
                SizedBox(height: 10,),
                PostButton(),
                SizedBox(height: 10,),

              ]),
        ),
      ),
    );
  }
}

class PostDescriptionErrorSection extends StatelessWidget {
  const PostDescriptionErrorSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,bloc,child)=>
      Visibility(
        visible: bloc.isAddNewPostError,
        child: Container(
          child: Text(
            "Post should not be empty",
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}

class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) =>
          GestureDetector(
            onTap: () {

              bloc.onTapAddNewPost().then((value) =>
                  Navigator.pop(context));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  // set the border stroke color here
                  width: 1,
                  // set the width of the border stroke here
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Post",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
    );
  }

}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) =>
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                // width: 300,
                child: TextField(
                  controller: TextEditingController(text: bloc.newPostDescription),
                  onChanged: (text) {
                    bloc.onNewPostTextChanged(text);
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Set the desired background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey, // Set the desired border color
                        width: 2.0, // Set the desired border width
                      ),


                    ),
                    hintText: 'What\'s on your mind?',
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

class ProfilePicAndProfileNameSection extends StatelessWidget {
  const ProfilePicAndProfileNameSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context,bloc,child)
      => Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                // set the border stroke color here
                width: 0,
                // set the width of the border stroke here
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(bloc.profilePicture),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            bloc.userName,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}


