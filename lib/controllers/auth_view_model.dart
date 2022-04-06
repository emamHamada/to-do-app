import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import '../services/firestore_user.dart';
import '../ui/pages/home_page.dart';

class AuthViewModel extends GetxController {
  String? email, pass, name;
  static Rx<User?>? _user;

  String? get user => _user?.value?.email;

//we get an instance for use it to google sign in
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

//we get an instance for use it to google sign in with firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookSignIn = FacebookLogin();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user?.bindStream(_auth.authStateChanges());
  }

  void googleSignInMethod() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print("$googleUser");
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential user = await _auth.signInWithCredential(credential);

    await saveUser(user);
    await Get.off(() => const HomePage());
    debugPrint("$user");
  }

  void signInWithFacebook() async {
    final FacebookLoginResult result =
        await _facebookSignIn.logIn(permissions: [FacebookPermission.email]);
    debugPrint("$result");

    final String? accessToken = result.accessToken?.token;
    debugPrint("$accessToken");
    if (result.status == FacebookLoginStatus.success) {
      final OAuthCredential facebookCredential =
          FacebookAuthProvider.credential(accessToken!);

      UserCredential user =
          await _auth.signInWithCredential(facebookCredential);

      await saveUser(user);
      await Get.off(() => const HomePage());
    }

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    debugPrint("$facebookAuthCredential");
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void signInWithEmailAndPass() async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email!, password: pass!);

      debugPrint("$user");
      await saveUser(user);
      await Get.off(() => const HomePage());
    } catch (error) {
      Get.snackbar("Error login Account", error.toString(),
          colorText: Colors.red, snackPosition: SnackPosition.TOP);
    }
  }

  void createAccount() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email!, password: pass!)
          .then((user) async {
        debugPrint("$user");
        await saveUser(user);
        await Get.offAll(() => const HomePage());
      });
    } catch (error) {
      Get.snackbar("Error login Account", error.toString(),
          colorText: Colors.red, snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> saveUser(UserCredential user) async {
    await FireStoreUser().addUser(
      UserModel(
        email: user.user?.email,
        name: name ?? user.user?.displayName,
        photo: '',
        userId: user.user?.uid,
      ),
    );
  }
}
