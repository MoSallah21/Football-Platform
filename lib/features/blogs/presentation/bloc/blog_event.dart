// blog_event.dart
part of 'blog_bloc.dart';

sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class GetAllBlogsEvent extends BlogEvent {}

class RefreshBlogsEvent extends BlogEvent {}
