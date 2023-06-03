import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/check_service.dart';
import '../service/user_service.dart';
import 'gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  bool isLoading = true;

  Map<String, dynamic>? myInfo;

  void initUserInfo() async {
    var userService = UserSerive();

    DocumentSnapshot snapshot =
        await userService.getMyInfo(userService.user()!.uid);
    myInfo = snapshot.data() as Map<String, dynamic>;

    print(myInfo);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var checkService = CheckService();

    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("오늘 출석"),
                        Spacer(),
                        //체크 버튼
                        ElevatedButton(
                          onPressed: () async {
                            checkService.check(myInfo!);
                          },
                          child: const Text("출석하기"),
                        )
                      ],
                    ),
                    //체크 목록
                    StreamBuilder(
                      stream: checkService.getChecks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var docs = snapshot.data!.docs;

                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              var current_user = docs[index];

                              return Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        current_user["profile_img"]),
                                  ),
                                  Text(current_user["name"]),
                                ],
                              );
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GalleryScreen(myInfo: myInfo!),
                          ),
                        );
                      },
                      child: const Text("갤러리"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
