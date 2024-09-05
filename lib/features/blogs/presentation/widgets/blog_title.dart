import 'package:flutter/material.dart';

class BlogTitle extends StatelessWidget {
  final String title;

  const BlogTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        shadows: [
          Shadow(
            color: Colors.purple,
            offset: Offset(2, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
