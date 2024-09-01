part of 'blog_bloc.dart';


abstract class BlogState{}

class BlogInitState extends BlogState{}

class GetAllBlogsSuccessState extends BlogState{
  final List<Blog> blogs;

  GetAllBlogsSuccessState({required this.blogs});

}

class GetAllBlogsErrorState extends BlogState{
  final String message;

  GetAllBlogsErrorState({required this.message});
}

class GetAllBlogsLoadingState extends BlogState{}



