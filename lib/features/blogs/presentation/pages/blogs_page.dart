import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';
import 'blog_description_page.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({Key? key}) : super(key: key);

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
              Text(
                'Football Blogs',
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
              Expanded(
                child: BlocBuilder<BlogBloc, BlogState>(
                  builder: (context, state) {
                    if (state is GetAllBlogsLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                        ),
                      );
                    } else if (state is GetAllBlogsErrorState) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is GetAllBlogsSuccessState) {
                      final blogs = state.blogs;
                      if (blogs.isEmpty) {
                        return Center(
                          child: Text(
                            'No blogs available.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: blogs.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return blogCard(blogs[index], context);
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: Text(
                          'Something went wrong!',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget blogCard(Blog blog, BuildContext context) {
  return InkWell(
    onTap: () {
      navigateToWithPush(
        context,
        BlogDescriptionScreen(
          title: blog.title,
          date: blog.dateOfPublish,
          author: blog.nameOfAuthor,
          image: blog.image,
          description: blog.description,
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
