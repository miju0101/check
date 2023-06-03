import 'package:recheck/screen/login_screen.dart';
import 'package:recheck/service/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(myInfo!["profile_img"]),
                        ),
                      ),
                      Text(myInfo!["name"]),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      var userService = UserSerive();
                      userService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text("로그아웃"),
                  )
                ],
              ),
            ),
    );
  }
}
