import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../size_config.dart';
import '../../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.label,
      required this.note,
      this.controller,
      this.widget})
      : super(key: key);
  final String label;
  final String? note;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 16),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth * .9,
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey)),
            child: TextFormField(
              style: subtitleStyle,
              autofocus: false,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              controller: controller,
              readOnly: widget != null ? true : false,
              decoration: InputDecoration(
                hintText: note,
                hintStyle: subtitleStyle,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 0,
                )),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 0,
                )),
                suffixIcon: widget,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This Field Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
