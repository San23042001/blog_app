import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function()? onPressed;
  final IconData? icon;
  final bool obscureText;
  final bool showSuffixIcon;
  final int maxLines;

  const CustomTextfield({
    super.key,
    this.controller,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.validator,
    this.onPressed,
    this.maxLines = 1,  
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines, 
      decoration: InputDecoration(
        suffixIcon: showSuffixIcon
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              )
            : null,
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
