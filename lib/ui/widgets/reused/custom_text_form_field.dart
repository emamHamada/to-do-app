import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
   const CustomTextFormField({Key? key, required this.label, required this.hint,  this.onSaved, this.validator}) : super(key: key);

 final String  label ;

 final String hint ;
final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(label: Text(label),hintText: hint,),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
