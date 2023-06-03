import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserSerive {
  User? user() {
    return FirebaseAuth.instance.currentUser;
  }

  //회원가입
  Future<int> signUp(String email, String password, String name) async {
    //회원가입에 성공하면 1, 실패하면 0을 반환
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //회원가입에 성공하면
      // 유저의 기본 정보 등록(이름, 이메일[아이디], uid, 프로필 이미지, )

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set(
        {
          "uid": user.user!.uid,
          "email": user.user!.email,
          "name": name,
          "profile_img":
              "https://firebasestorage.googleapis.com/v0/b/recheck-d3ef1.appspot.com/o/default%2Fdefault_user_img.jpeg?alt=media&token=28f09e32-3ecd-4b10-b29e-01434a60a099",
        },
      );

      return 1;
    } catch (e) {
      print(e.toString());
    }

    return 0;
  }

  //일반 로그인
  Future<void> signIn(String email, String password) async {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }

  //구글 로그인 - 디지털 지문을 등록해야 가능
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = await GoogleAuthProvider.credential(
        idToken: googleAuth!.idToken, accessToken: googleAuth!.accessToken);

    UserCredential myInfo =
        await FirebaseAuth.instance.signInWithCredential(credential);

    FirebaseFirestore.instance.collection("users").doc(myInfo.user!.uid).set({
      "uid": myInfo.user!.uid,
      "email": myInfo.user!.email,
      "name": myInfo.user!.displayName,
      "profile_img": myInfo.user!.photoURL,
    });
  }

  //유저의 기본정보
  Future<DocumentSnapshot> getMyInfo(String uid) {
    return FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  //로그아웃
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //프로필 사진 변경
  void changeProfileImg() async {
    XFile? selectedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {}
  }
}
