import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikeButton extends StatelessWidget {

  void Function()? onTapFunc;
  final bool isLiked;

  LikeButton({super.key, required this.onTapFunc, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunc,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}