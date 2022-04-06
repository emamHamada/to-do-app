import 'package:flutter/material.dart';

import '../../theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(

       // margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blueGrey[300]),
        height: 45,
        child: Text(
          label,
          style: subHeadingStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
