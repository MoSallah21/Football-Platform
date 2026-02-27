part of 'blog_bloc.dart';

sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitState extends BlogState {}

class GetAllBlogsLoadingState extends BlogState {}

class GetAllBlogsSuccessState extends BlogState {
  final List<Blog> blogs;

  const GetAllBlogsSuccessState({required this.blogs});

  @override
  List<Object?> get props => [blogs];
}

class GetAllBlogsErrorState extends BlogState {
  final String message;

  const GetAllBlogsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

// Additional state for when showing cached data with error
class GetAllBlogsCachedWithErrorState extends BlogState {
  final List<Blog> blogs;
  final String errorMessage;

  const GetAllBlogsCachedWithErrorState({
    required this.blogs,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [blogs, errorMessage];
}