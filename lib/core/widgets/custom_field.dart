import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? textEditingController;
  final bool isObscureText;
  final bool isReaOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.isObscureText = false,
    this.isReaOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isReaOnly,
      onTap: onTap,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (val){
        if(val!.trim().isEmpty){
          return "Please Enter $hintText";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
