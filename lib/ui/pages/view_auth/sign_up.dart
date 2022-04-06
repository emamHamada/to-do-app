import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_view_model.dart';

import '../../widgets/reused/custom_buttons.dart';
import '../../widgets/reused/custom_text.dart';
import '../../widgets/reused/custom_text_form_field.dart';
import 'log_in.dart';

class SignUp extends GetWidget<AuthViewModel> {
  SignUp({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
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
                CustomText(
                  text: 'SIGN UP,',
                  color: Colors.black,
                  size: 30,
                  bolden: FontWeight.bold,
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomTextFormField(
                  hint: 'Hamadan',
                  label: 'Name',
                  onSaved: (value) {
                    controller.name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'name  must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
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
                CustomButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        controller.createAccount();
                      }
                    },
                    name: CustomText(
                      text: 'SIGN UP',
                      color: Colors.white,
                      size: 20,
                      bolden: FontWeight.normal,
                    ),
                    w: 300,
                    h: 75),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
