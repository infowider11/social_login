import 'package:flutter/material.dart';
import 'package:social_login/social_login_service.dart';
import 'package:social_login/user_social_login_detail_modal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              SocialLoginServices socialLoginServices = SocialLoginServices();
              UserSocialLoginDeatilModal? userDeatils =
                  await socialLoginServices.signInWithGoogle();
              if (userDeatils != null) {
                print(
                    "user google sigin details is that ${userDeatils.toJson()}");
              }
            },
            child: const Text("Google Login"),
          ),
          ElevatedButton(
            onPressed: () async {
              SocialLoginServices socialLoginServices = SocialLoginServices();
              UserSocialLoginDeatilModal? userDeatils =
                  await socialLoginServices.facebookLogin();
              if (userDeatils != null) {
                print(
                    "user facebook sigin details is that ${userDeatils.toJson()}");
              }
            },
            child: const Text("Facebook Login"),
          ),
        ],
      ),
    );
  }
}
