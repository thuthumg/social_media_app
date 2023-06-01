import 'package:firebase_database/firebase_database.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

///Database Paths
const newsFeedPath = "newsfeed";

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent{

  static final RealtimeDatabaseDataAgentImpl _singleton =
  RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl(){
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  ///Database
  var databaseRef = FirebaseDatabase.instance.reference();

 // DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(newsFeedPath).onValue.map((event) {

      List<Object?> snapshotData = (event.snapshot.value as List<Object?>);
      List<Object?> mutableList = List.from(snapshotData);
      mutableList.removeAt(0);

      print("check value = ${mutableList.length}");
      return (mutableList).map<NewsFeedVO>((element) {
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(element as Map<dynamic,dynamic>));
      }).toList();
    });
  }

  // @override
  // Stream<List<NewsFeedVO>> getNewsFeed() {
  //
  //
  //
  //   // databaseReference.child(newsFeedPath).once().then((snapshot) {
  //   //   // Handle the retrieved data
  //   //   var data = snapshot.snapshot.value;
  //   //   // Process the data as needed
  //   // }).catchError((error) {
  //   //   // Handle any errors that occur
  //   //   print('Error: $error');
  //   // });
  //
  //
  //  return databaseRef.child(newsFeedPath).onValue.map((event){
  //
  //    return (event.snapshot.value as List<Object>).map<NewsFeedVO>((element){
  //      return NewsFeedVO.fromJson(Map<String,dynamic>.from(element as Map<dynamic,dynamic>));
  //  }).toList();
  //
  //  });
  //
  //
  // }

}