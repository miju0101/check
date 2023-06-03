import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CheckService {
  // check/{today}/{uid - name, profile_img}
  void check(Map<String, dynamic> userInfo) async {
    String now = DateFormat('yyMMdd').format(DateTime.now());
    FirebaseFirestore.instance
        .collection('check')
        .doc(now)
        .collection("users")
        .doc(userInfo["uid"])
        .set({
      "name": userInfo["name"],
      "profile_img": userInfo["profile_img"],
      "uid": userInfo["uid"]
    });
  }

  //오늘 출석한 사람을 가져옴
  Stream<QuerySnapshot> getChecks() {
    String now = DateFormat('yyMMdd').format(DateTime.now());

    //check/{now}/users/{uid}
    return FirebaseFirestore.instance
        .collection('check')
        .doc(now)
        .collection("users")
        .snapshots();
  }
}
