import 'package:recheck/service/user_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var email = TextEditingController();
    var password = TextEditingController();
    var name = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("회원가입"),
      ),
      body: Column(
        children: [
          Text("이름"),
          TextField(controller: name),
          Text("이메일"),
          TextField(controller: email),
          Text("비밀번호"),
          TextField(controller: password),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          if (name.text.isNotEmpty &&
              email.text.isNotEmpty &&
              password.text.isNotEmpty) {
            var userService = UserSerive();

            int state =
                await userService.signUp(email.text, password.text, name.text);

            if (state == 1) {
              Navigator.pop(context);
            }
          }
        },
        child: Text("회원가입 하기"),
      ),
    );
  }
}
