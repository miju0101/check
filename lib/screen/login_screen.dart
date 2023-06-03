import 'package:recheck/screen/main_screen.dart';
import 'package:recheck/screen/sign_up_screen.dart';
import 'package:recheck/service/user_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userService = UserSerive();
    var email = TextEditingController();
    var password = TextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("로그인"),
          TextField(
            controller: email,
          ),
          TextField(
            controller: password,
          ),
          ElevatedButton(
            onPressed: () async {
              if (email.text.isNotEmpty && password.text.isNotEmpty) {
                await userService.signIn(email.text, password.text);
                if (userService.user() != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                }
              }
            },
            child: const Text("로그인"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            },
            child: Text("회원가입"),
          ),
          ElevatedButton(
            onPressed: () async {
              await userService.signInWithGoogle();
              if (userService.user() != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              }
            },
            child: const Text("구글 로그인"),
          ),
        ],
      ),
    );
  }
}
