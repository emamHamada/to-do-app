import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomButton extends StatelessWidget {

  CustomButton({Key? key, this.name,this.w, required this.onPressed, this.h})
      : super(key: key);
  void Function()? onPressed;
  Widget? name;
  double? w;
  double? h;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      width: w,
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: onPressed,
          child: name,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor)),
        ));
  }
}
