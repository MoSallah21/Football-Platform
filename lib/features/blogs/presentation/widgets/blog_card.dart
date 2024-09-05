import 'package:flutter/material.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/presentation/pages/blog_description_page.dart';

Widget blogCard(Blog blog, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogDescriptionScreen(
            title: blog.title,
            date: blog.dateOfPublish,
            author: blog.nameOfAuthor,
            image: blog.image,
            description: blog.description,
          ),
        ),
      );
    },
    child: Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      color: Colors.purple.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              blog.image,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                blog.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
