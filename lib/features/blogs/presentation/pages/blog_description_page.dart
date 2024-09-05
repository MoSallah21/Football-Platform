import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart' as s;

class BlogDescriptionScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String date;
  final String author;

  BlogDescriptionScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        DateTime dateTime = DateTime.parse(date);
        String formattedDate = s.DateFormat('yyyy-MM-dd').format(dateTime);
        return Scaffold(
          backgroundColor: HexColor('#202124'),
          body: Scrollbar(
            thickness: 2.0,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    image,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
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
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Via $author',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.purple,
                              offset: Offset(2, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Published in $formattedDate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.purple,
                              offset: Offset(2, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
