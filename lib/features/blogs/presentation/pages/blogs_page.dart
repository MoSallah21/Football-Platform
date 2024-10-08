import 'package:flutter/material.dart';
import 'package:football_platform/core/componants/background.dart';
import 'package:football_platform/features/blogs/presentation/widgets/blog_list.dart';
import 'package:football_platform/features/blogs/presentation/widgets/blog_title.dart';
import 'package:hexcolor/hexcolor.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#202124'),
      body: BackGround(
        img: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              BlogTitle(title: 'Football Blogs'),
              Expanded(child: BlogList()),
            ],
          ),
        ),
      ),
    );
  }
}
