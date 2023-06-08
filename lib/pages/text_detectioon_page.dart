

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/text_detection_bloc.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/widgets/primary_button_view.dart';

class TextDetectionPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> TextDetectionBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 30,
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: ()=> Navigator.pop(context),
            child: Row(
              children: const [
                SizedBox(width: MARGIN_MEDIUM,),
                Icon(Icons.chevron_left,color: Colors.black,),
                SizedBox(width: MARGIN_SMALL,),
                Text("BACK",style: TextStyle(color: Colors.black),)
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_LARGE),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<TextDetectionBloc>(
                    builder: (context,bloc,child){
                      return Visibility(
                        visible: bloc.chosenImageFile != null,
                          child: Image.file(
                            bloc.chosenImageFile ?? File(""),
                            width: 300,
                            height: 300,
                          ));
                    }),
                const SizedBox(height: MARGIN_LARGE,),
                Consumer<TextDetectionBloc>(
                    builder: (context,bloc,child)=>GestureDetector(
                      onTap: (){
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((pickedImageFile) async {
                              var bytes = await pickedImageFile?.readAsBytes();
                              bloc.onImageChosen(
                                File(pickedImageFile?.path ?? ""),
                                bytes ?? Uint8List(0)
                              );
                        }).catchError((error){
                          showSnackBarWithMessage(context,"Image Cannot be picked");
                        });
                      },
                      child: const PrimaryButtonView(label: "Choose Image"),
                    ))

              ],
            ),
          ),
        ),
      ),
    );
  }

}

