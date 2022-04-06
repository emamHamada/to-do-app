import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/ui/pages/view_auth/sign_up.dart';

import '../../../controllers/auth_view_model.dart';
import '../../widgets/constants/constants.dart';
import '../../widgets/reused/custom_buttons.dart';
import '../../widgets/reused/custom_buttons_social.dart';
import '../../widgets/reused/custom_text.dart';
import '../../widgets/reused/custom_text_form_field.dart';

class LoginScreen extends GetWidget<AuthViewModel> {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white.withOpacity(.5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Welcome,',
                      color: Colors.black,
                      size: 30,
                      bolden: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SignUp());
                      },
                      child: CustomText(
                        text: 'SIGNUP',
                        color: primaryColor,
                        size: 20,
                        bolden: FontWeight.normal,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomTextFormField(
                  hint: 'email@email.com',
                  label: 'Email',
                  onSaved: (value) {
                    controller.email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'email  must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  hint: '**************',
                  label: 'Password',
                  onSaved: (value) {
                    controller.pass = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'pass  must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  align: Alignment.topRight,
                  text: 'Forget Password?',
                  color: Colors.black.withOpacity(.5),
                  size: 12,
                  bolden: FontWeight.normal,
                  padding: const EdgeInsets.only(right: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        controller.signInWithEmailAndPass();
                      }
                    },
                    name: CustomText(
                      text: 'SIGN IN',
                      color: Colors.white,
                      size: 20,
                      bolden: FontWeight.normal,
                    ),
                    w: 300,
                    h: 75),
                Divider(
                  thickness: 2,
                  color: Colors.red[300],
                ),
                CustomButtonSocial(
                  onPressed: () {
                    controller.signInWithFacebook();
                  },
                  assetsName: 'assets/icons/facebook.png',
                ),
                Divider(
                  thickness: 1,
                  color: Colors.red[300],
                ),
                CustomButtonSocial(
                  onPressed: () {
                    controller.googleSignInMethod();
                  },
                  assetsName: 'assets/icons/google.jpg',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
