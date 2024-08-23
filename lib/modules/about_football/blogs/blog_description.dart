import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart' as s;

class BlogDescriptionScreen extends StatelessWidget {
  BlogDescriptionScreen({
    super.key, required this.title, required this.description, required this.image, required this.date, required this.author,
  });
  final String title;
  final String description;
  final String image;
  final String date;
  final String author;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AboutCubit,AboutState>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        DateTime dateTime = DateTime.parse(date);
        String formattedDate = s.DateFormat('yyyy-MM-dd').format(dateTime);
        return  Scaffold(
          backgroundColor: HexColor('#202124'),
                body: Scrollbar(
        thickness: 2.0, // Set thickness of the scrollbar
        child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 16),
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
                color: Colors
                    .purple, // Change to the desired purple color
                offset: Offset(2,
                    1), // Adjust the offset based on your preference
                blurRadius:
                2, // Adjust the blur radius based on your preference
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
        style: TextStyle(fontSize: 16,color: Colors.white),
        ),
        SizedBox(height: 20),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
        'Via ${author}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Colors
                    .purple, // Change to the desired purple color
                offset: Offset(2,
                    1), // Adjust the offset based on your preference
                blurRadius:
                2, // Adjust the blur radius based on your preference
              ),
            ],
          ),
        ),
        Text(
        'Published in ${formattedDate}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Colors
                    .purple, // Change to the desired purple color
                offset: Offset(2,
                    1), // Adjust the offset based on your preference
                blurRadius:
                2, // Adjust the blur radius based on your preference
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
