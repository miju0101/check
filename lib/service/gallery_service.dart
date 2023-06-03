import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class GalleryService {
  //이미지 업로드 여러개
  void uploadImages(Map<String, dynamic> myInfo) async {
    List<XFile>? selectedFiles = await ImagePicker().pickMultiImage();

    if (selectedFiles != null && selectedFiles.length > 0) {
      var files = List.generate(
          selectedFiles.length, (index) => File(selectedFiles[index].path));

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference doc =
              await FirebaseFirestore.instance.collection("gallery").doc();

          List tasks = [];

          for (File file in files) {
            UploadTask task = FirebaseStorage.instance
                .ref()
                .child("gallery")
                .child(doc.id)
                .child(basename(file.path).split(".").first)
                .putFile(file);

            tasks.add(task);
          }

          List<String> urls = [];

          await Future.wait(tasks.map((task) async {
            TaskSnapshot snapshot = await task;

            if (snapshot.state == TaskState.success) {
              var url = await snapshot.ref.getDownloadURL();

              urls.add(url);
            }
          }));

          await FirebaseFirestore.instance
              .collection("gallery")
              .doc(doc.id)
              .set({
            "uid": myInfo["uid"],
            "name": myInfo["name"],
            "profile_img": myInfo["profile_img"],
            "sendDate": DateTime.now(),
            "photo_url": urls,
          });
        });

        print("최종 저장완료");
      } catch (e) {
        print("트랜잭션 실패");
      }
    }
  }

  Stream<QuerySnapshot> getPhotos() {
    return FirebaseFirestore.instance
        .collection("gallery")
        .orderBy("sendDate", descending: true)
        .snapshots();
  }

  //이미지 다운로드
  void downLoadImg(String url) async {}

  void deleteImg(String docId) async {
    await FirebaseFirestore.instance.collection("gallery").doc(docId).delete();

    // 이미지 삭제
    Reference folderRef =
        FirebaseStorage.instance.ref().child("gallery").child(docId);
    ListResult listResult = await folderRef.listAll();

    for (final item in listResult.items) {
      await item.delete();
    }

    // 폴더 삭제
    //await folderRef.delete();

    print("이미지 및 폴더 삭제가 완료되었습니다.");
  }

  //최근 올린 사진 가져오기
  Future<QuerySnapshot> getTheseDaysPhotos() {
    return FirebaseFirestore.instance
        .collection("gallery")
        .orderBy("sendDate", descending: true)
        .limit(7)
        .get();
  }
}
