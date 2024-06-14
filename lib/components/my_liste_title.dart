import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyListTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  void Function()? onTap;

  MyListTitle({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white,),
        title: Text(text, style: const TextStyle(color: Colors.white),),
        onTap: onTap,
      ),
    );
  }
}