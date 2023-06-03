import 'package:recheck/screen/look_photo_screen.dart';
import 'package:recheck/service/gallery_service.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  final Map<String, dynamic> myInfo;

  const GalleryScreen({required this.myInfo});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    var galleryService = GalleryService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("갤러리"),
        actions: [
          //이미지 올리기
          ElevatedButton(
            onPressed: () {
              galleryService.uploadImages(widget.myInfo);
            },
            child: Text("올리기"),
          )
        ],
      ),
      body: StreamBuilder(
        stream: galleryService.getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var doc = snapshot.data!.docs;

            return GridView.builder(
              itemCount: doc.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                var current_img = doc[index];
                print(current_img);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LookPhotoScreen(
                            photo_info: current_img,
                            myUid: widget.myInfo["uid"]),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          current_img["photo_url"][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      //이미지 개수
                      if (current_img["photo_url"].length > 1)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child:
                              Text("+${current_img["photo_url"].length - 1}"),
                        ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("데이터를 가져오는 중..."),
            );
          }
        },
      ),
    );
  }
}
