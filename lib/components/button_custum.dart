import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonCustum extends StatelessWidget {
  final Function()? onTapFunc;
  final String text;
  ButtonCustum({super.key, required this.onTapFunc, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunc,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}