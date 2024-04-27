import 'package:firebase_database/firebase_database.dart';
import 'package:zohoclone/models/user_model.dart';

class FireBaseHelper {

  static void readUserInfoFromRealTime () {

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("users");
    UserModel? userModel ;

    ref.once().then((snap) {
      if(snap.snapshot.value != null){
        userModel = UserModel.fromJson(snap.snapshot);
        print(snap.snapshot.value);
      }
    });
  }
}