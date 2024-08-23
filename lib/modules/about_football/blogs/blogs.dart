import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/blog_model/blog_model.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';
import 'blog_description.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutCubit, AboutState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=AboutCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: HexColor('#202124'),
            body: BackGround(
              img: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Text(
                      'Football Blogs',
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
                    Expanded(
                      child: StreamBuilder<List<BlogModel>>(
                        stream: cubit.getBlogs(), // Replace with your stream
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(color: Colors.purple,));
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            final blogs = snapshot.data ?? [];
                            return ListView.builder(
                              itemCount: blogs.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return blogCard(blogs[index],context);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget blogCard(BlogModel blogs,context){
  return InkWell(
    onTap:() {
      navigateToWithPush(context,
          BlogDescriptionScreen(
            title: blogs.title,
            date: blogs.dateOfPublish,
            author: blogs.nameOfAuthor,
            image: blogs.image,
            description: blogs.description,


          ));
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
              blogs.image,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                blogs.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
