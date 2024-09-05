import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/blogs/presentation/widgets/blog_card.dart';

class BlogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
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
    );
  }
}
