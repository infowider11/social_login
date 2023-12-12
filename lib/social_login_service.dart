import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login/user_social_login_detail_modal.dart';

class SocialLoginServices {
  Future<UserSocialLoginDeatilModal?> signInWithGoogle() async {
    final firebaseAuth = FirebaseAuth.instance;

    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    print('googleAccount $googleAccount');
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final authResult = await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );
      // return _userFromFirebase(authResult.user);
      print('the user data is ${authResult}');
      Map<String, dynamic> data = {
        'uid': authResult.user?.uid,
        'name': authResult.user?.displayName,
        'email': authResult.user?.email ?? '',
        'type': 'Google'
        // 'fname':authResult.additionalUserInfo.
      };
      await googleSignIn.disconnect();
      print('google login successfully-------------- ${data}');
      Map<String, dynamic> request = {
        'email': authResult.user?.email ?? '',
        'google_id': authResult.user?.uid
      };
      print("request data is $request");
      return UserSocialLoginDeatilModal(
          socialLoginId: authResult.user!.uid,
          emailId: authResult.user!.email!,
          userName: authResult.user!.displayName!);
    } else {
      print("Some thing went wrong");
      return null;
    }
  }

  Future<UserSocialLoginDeatilModal?> facebookLogin() async {
    // Create an instance of FacebookLogin
    final fb = FacebookLogin();
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile, // permission to get public profile
      FacebookPermission.email, // permission to get email address
    ]);
    // Check result status
    if (res.status == FacebookLoginStatus.success) {
      final FacebookAccessToken? accessToken =
          res.accessToken; // get accessToken for auth login
      final profile = await fb.getUserProfile(); // get profile of user
      final imageUrl =
          await fb.getProfileImageUrl(width: 100); // get user profile image
      final email = await fb.getUserEmail(); // get user's email address

      print('fb data Access token: ${accessToken?.token}');
      print('fb data Hello, ${profile!.name}! You ID: ${profile.userId}');
      print('fb data Your profile image: $imageUrl');
      print('fb data And your email is $email');
      return UserSocialLoginDeatilModal(
          socialLoginId: profile.userId,
          emailId: email ?? "",
          userName: profile.name!);
    } else if (res.status == FacebookLoginStatus.cancel) {
      return null;
    } else if (res.status == FacebookLoginStatus.error) {
      print('Error while log in: ${res.error}');
      return null;
    }
    print('Error while log in: ${res.error}');
    return null;
  }
}
