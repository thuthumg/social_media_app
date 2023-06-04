import 'package:flutter/material.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedEachItemWidget extends StatelessWidget{

  final Function(int) onTapDelete;
  final Function(int) onTapEdit;
  final NewsFeedVO? newsFeedVO;

  NewsFeedEachItemWidget({
    required this.newsFeedVO,
    required this.onTapDelete,
    required this.onTapEdit
});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(20),
     child: Container(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Row(children: [
                 ProfileSection(newsFeedVO: newsFeedVO,),
                 SizedBox(width: 10,),
                 NameAndPostTimeSection(newsFeedVO: newsFeedVO,),
               ],),
               MoreButtonSection(
                 onTapDelete: (){
                 onTapDelete(newsFeedVO?.id ?? 0);
               },
               onTapEdit: (){
                 onTapEdit(newsFeedVO?.id ?? 0);
               },
               )
             ],),
           const SizedBox(height: 10,),
           PostDescriptionSection(newsFeedVO: newsFeedVO,),
           const SizedBox(height: 10,),
           CommentAndLikeSection()
         ],
       ),
     ),
   );
  }

}

class MoreButtonSection extends StatelessWidget {

  Function onTapDelete;
  Function onTapEdit;

  MoreButtonSection({
    super.key,
    required this.onTapDelete,
    required this.onTapEdit
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(icon: const Icon(Icons.more_vert_outlined,color: Colors.grey,),
    itemBuilder: (context)=>
      [
        PopupMenuItem(
          onTap: (){
            onTapEdit();
          },
          child: Text("Edit"),value: 1,),
        PopupMenuItem(
          onTap: (){
            onTapDelete();
          },
          child: Text("Delete"),value: 2,)
      ],);
  }
}


class CommentAndLikeSection extends StatelessWidget {
  const CommentAndLikeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("See Comments",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
        Row(
          children: [
            Icon(Icons.mode_comment_outlined,color: Colors.grey,),
            SizedBox(width: 10,),
            Icon(Icons.favorite_border,color: Colors.grey,),
          ],
        )
      ],);
  }
}

class PostDescriptionSection extends StatelessWidget {
  final NewsFeedVO? newsFeedVO;
  const PostDescriptionSection({
    super.key,
    required this.newsFeedVO
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: (newsFeedVO?.postImage=="")? false: true,
            child: UploadPhotoSection(newsFeedVO: newsFeedVO,)),
        SizedBox(height: 20,),
        TextDescriptionSection(newsFeedVO: newsFeedVO,),
      ],
    );
  }
}

class TextDescriptionSection extends StatelessWidget {
  final NewsFeedVO? newsFeedVO;
  const TextDescriptionSection({
    super.key,
    required this.newsFeedVO
  });

  @override
  Widget build(BuildContext context) {
    return Text("${newsFeedVO?.description}",
        style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600));
  }
}

class UploadPhotoSection extends StatelessWidget {
  final NewsFeedVO? newsFeedVO;
  const UploadPhotoSection({
    super.key,
    required this.newsFeedVO
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      // width: 200, // Set the desired width of the container
      height: 200, // Set the desired height of the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Set the desired corner radius value
        image: DecorationImage(
          image: NetworkImage('${newsFeedVO?.postImage}'), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class NameAndPostTimeSection extends StatelessWidget {
  final NewsFeedVO? newsFeedVO;

  const NameAndPostTimeSection({
    super.key,
    required this.newsFeedVO
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${newsFeedVO?.userName}",
                style: TextStyle(
                    color: Color.fromRGBO(85, 85, 85, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            SizedBox(width: 10,),
            Text(".2 hours ago",
                style: TextStyle(
                    color: Color.fromRGBO(85, 85, 85, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w600))
          ],
        ),
        Text("Paris",
            style: TextStyle(
                color: Color.fromRGBO(85, 85, 85, 1),
                fontSize: 12,
                fontWeight: FontWeight.w600))
      ],
    );
  }
}

class ProfileSection extends StatelessWidget {
  final NewsFeedVO? newsFeedVO;

  const ProfileSection({
    super.key,
    required this.newsFeedVO
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3.0,bottom: 3.0),
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
          image: AssetImage("${newsFeedVO?.profilePicture}"),
        ),
      ),
    );
  }
}