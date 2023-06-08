import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/add_new_post_bloc.dart';
import 'package:social_media_app/widgets/loading_view.dart';

class AddNewPostPage extends StatelessWidget {
  final int? newsFeedId;

  AddNewPostPage({this.newsFeedId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewPostBloc(newsFeedId: newsFeedId),
      child: Selector<AddNewPostBloc,bool>(
        selector: (context,bloc)=> bloc.isLoading,
        builder:(context , isLoading,child)=> Stack(
          children: [
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
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(children: const [
                      ProfilePicAndProfileNameSection(),
                      SizedBox(
                        height: 10,
                      ),
                      DescriptionSection(),
                      SizedBox(
                        height: 10,
                      ),
                      PostDescriptionErrorSection(),
                      PostImageView(),
                      SizedBox(
                        height: 10,
                      ),
                      PostButton(),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
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
    );
  }
}



class PostImageView extends StatelessWidget {
  const PostImageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
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
                        height: 300,
                        child: (bloc.mNewsFeed?.postImage != null && bloc.mNewsFeed?.postImage != "")?
                        Center(child: Image.network("${bloc.mNewsFeed?.postImage}",fit: BoxFit.cover,)):
                        Center(child: Image.asset("assets/images/empty_photo.png",fit: BoxFit.cover,scale: 5,)),
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
                      height: 300,
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

class PostDescriptionErrorSection extends StatelessWidget {
  const PostDescriptionErrorSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewPostBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isAddNewPostError,
        child: Container(
          child: Text(
            "Post should not be empty",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
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
      builder: (context, bloc, child) => GestureDetector(
        onTap: () {
          bloc.onTapAddNewPost().then((value) => Navigator.pop(context));
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: bloc.themeColor,
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
      builder: (context, bloc, child) => Expanded(
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
      builder: (context, bloc, child) => Row(
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
                image: NetworkImage(bloc.profilePicture),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            bloc.userName,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
