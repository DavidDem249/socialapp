import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustum extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  //final String? onTapValidate Function();
  String? Function(String?)? onTapValidate;

  TextFieldCustum({super.key, required this.controller, required this.hintText, required this.obscureText, required this.onTapValidate});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: onTapValidate,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            //borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}