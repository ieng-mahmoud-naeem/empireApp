import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.validator,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
  });
  final String hintText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        style: const TextStyle(
          fontFamily: 'ElMessiri',
          color: Colors.black,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          suffix: icon,
          filled: false,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'ElMessiri',
            color: Colors.black,
            fontSize: 18,
          ),
          fillColor: Colors.grey,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Colors.black)),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
