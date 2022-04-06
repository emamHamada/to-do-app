import 'package:flutter/material.dart';

class CustomButtonSocial extends StatelessWidget {
  CustomButtonSocial(
      {Key? key,
      required this.assetsName,
      this.w,
      required this.onPressed,
      this.h})
      : super(key: key);
  void Function()? onPressed;
  String assetsName;
  double? w;
  double? h;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.shade200,
        ),
        height: h,
        width: w,
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: onPressed,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Image.asset(
              assetsName,
              width: 50,
              height: 60,
                filterQuality: FilterQuality.high,
            ),
            const Text('Sign in with facebook',style: TextStyle(fontSize: 16),)
          ]),
        ));
  }
}
